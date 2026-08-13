class Rt < Formula
  desc "Overlay type system for Unix shell pipelines"
  homepage "https://github.com/atlas-brown/rt"
  url "https://github.com/atlas-brown/rt/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dafd2a5f1c9c36918ab598b14a7b8f99bc194e6b55077acc4219b2347ecb3559"
  license :cannot_represent
  head "https://github.com/atlas-brown/rt.git", branch: "main"

  depends_on "docker" => :test

  def install
    bin.install "scripts/run-in-container.sh" => "rt"
    bin.install_symlink "rt" => "rti"
  end

  def caveats
    <<~EOS
      rt and rti require Docker.

        Install Docker: https://docs.docker.com/get-docker/

    EOS
  end

  test do
    assert_predicate bin/"rt", :executable?
    assert_predicate bin/"rti", :executable?
    assert_match "docker", File.read(bin/"rt")
  end
end
