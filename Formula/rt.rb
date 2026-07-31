class Rt < Formula
  desc "Overlay type system for Unix shell pipelines"
  homepage "https://github.com/atlas-brown/rt"
  # TODO: replace fields with atlas-brown/rt
  url "https://github.com/davidkovach-fuentes/rt/archive/refs/tags/v0.1.0.tar.gz"
  # url "https://github.com/atlas-group/rt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1d93946042dd1b50969e8862897d633e939f630c5ef7fa33c44e2f3ee238d28b"
  license :cannot_represent

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
