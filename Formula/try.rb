class Try < Formula
  desc "Run a command, see its filesystem changes, then keep or roll them back"
  homepage "https://github.com/atlas-brown/try-mac"
  # The source repository is private, so the archive download needs GitHub
  # credentials. `GitHub::API.credentials` is Homebrew's own credential lookup:
  # it tries HOMEBREW_GITHUB_API_TOKEN, then the `gh` CLI login, then the macOS
  # keychain -- so most users need no extra setup.
  url "https://github.com/atlas-brown/try-mac/archive/refs/tags/v0.0.2.tar.gz",
      headers: ["Authorization: Bearer #{GitHub::API.credentials}"]
  sha256 "a336c7b9af4146c484e8b6a97436e2fc9aa7e1d33d8e31775c626f6ab1899e4b"
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
    # The package is `try-mac`; the product it builds is `try`.
    system "swift", "build", *std_swift_args,
           "--product", "try",
           "--scratch-path", buildpath/".build"
    bin.install ".build/release/try"
  end

  def caveats
    <<~EOS
      Don't run `try` as sudo:

        try -- <command>

      try starts `eslogger` for you to read Endpoint Security events, and only
      that part needs root, so it asks for your password. Your command still runs
      as you. Running the whole of try under sudo would run your command as root
      as well.

      The terminal you run it in also needs Full Disk Access, or `eslogger` never
      becomes ready:

        System Settings > Privacy & Security > Full Disk Access
    EOS
  end

  # A real run takes an APFS snapshot and asks for a password to start
  # `eslogger`, so the test has to stay with the paths that fail before any of
  # that: `brew test` must not block on a prompt or touch the live system.
  test do
    assert_match "capture its filesystem changes", shell_output("#{bin}/try --help")
    # Input errors exit 2, and try prints them on stderr.
    assert_match "no command given", shell_output("#{bin}/try 2>&1", 2)
    assert_match "unknown option", shell_output("#{bin}/try --not-an-option -- true 2>&1", 2)
  end
end
