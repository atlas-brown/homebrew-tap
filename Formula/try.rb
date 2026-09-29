class Try < Formula
  desc "Run a command, see its filesystem changes, then keep or roll them back"
  homepage "https://github.com/atlas-brown/try-mac"
  # The source repository is private, so the archive download needs GitHub
  # credentials. `GitHub::API.credentials` is Homebrew's own credential lookup:
  # it tries HOMEBREW_GITHUB_API_TOKEN, then the `gh` CLI login, then the macOS
  # keychain -- so most users need no extra setup.
  url "https://github.com/atlas-brown/try-mac/archive/refs/tags/v0.1.0.tar.gz",
      headers: ["Authorization: Bearer #{GitHub::API.credentials}"]
  sha256 "a9bfd13a540ef88242c989f81476c560b961a0dcc1b5baf78c1622639ca57463"
  license :cannot_represent

  # `brew install --HEAD atlas-brown/tap/try` builds the tip of `main`. Cloning a
  # private repository over HTTPS needs a git credential helper, because Homebrew
  # sets GIT_TERMINAL_PROMPT=0 and git cannot ask for a password. `gh auth login`
  # and `gh auth setup-git` both configure one.
  head "https://github.com/atlas-brown/try-mac.git", branch: "main"

  # `brew livecheck try` reads tags straight from the repository, because the
  # releases page is not public. `git ls-remote` uses the same credential helper
  # as the HEAD clone above.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git
  end

  # Package.swift declares .macOS(.v13).
  depends_on macos: :ventura

  # The Swift compiler ships with the Command Line Tools, which Homebrew already
  # requires, and the package has no external dependencies -- so there is
  # nothing else to declare and the build needs no network access.

  def install
    # The package is `try-mac`; the Swift product it builds is `try-core`, a
    # file-in/file-out worker. The user-facing commands are the two shell
    # scripts at the repo root -- bin/try (orchestrator) and bin/try-eslogger
    # (sudo/askpass wrapper). The scripts look for try-core next to themselves
    # first, then on PATH, so all three must land in prefix `bin/` together.
    system "swift", "build", *std_swift_args,
           "--product", "try-core",
           "--scratch-path", buildpath/".build"
    bin.install ".build/release/try-core", "bin/try", "bin/try-eslogger"
  end

  def caveats
    <<~EOS
      `try` needs root only for the event-capture step (starting `eslogger`),
      and prompts for it with a dialog -- so don't run `try` as root. The
      terminal also needs Full Disk Access for eslogger to see events:

        System Settings > Privacy & Security > Full Disk Access

      `try rollback` needs neither: it restores from the APFS local snapshot
      taken at run time, via `tmutil`, without asking for a password.
    EOS
  end

  # A real run takes an APFS snapshot and asks for a password to start
  # `eslogger`, so the test has to stay with the paths that fail before any of
  # that: `brew test` must not block on a prompt or touch the live system.
  test do
    # bin/try is a bash script whose usage text goes to stderr, so capture
    # both streams. The other two paths below fail before any snapshot or
    # eslogger work: `brew test` must not block on a prompt or touch the live
    # system.
    assert_match "capture its filesystem changes", shell_output("#{bin}/try --help 2>&1")
    # Input errors exit 2, and try prints them on stderr.
    assert_match "no command given", shell_output("#{bin}/try 2>&1", 2)
    assert_match "unknown option", shell_output("#{bin}/try --not-an-option -- true 2>&1", 2)
  end
end
