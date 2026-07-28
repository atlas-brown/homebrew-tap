class Rt < Formula
  desc 'Overlay type system for Unix shell pipelines'
  homepage 'https://github.com/atlas-brown/rt'
  version '0.1.0'
  license :cannot_represent
  # TODO: replace fields with atlas/rt
  url "https://github.com/davidkovach-fuentes/rt/releases/download/v#{version}/rt-#{version}.tar.gz"
  sha256 '3e70ed713350a5ca7691ebf441b1f5abd15f3be4a2cf1506f682cdf01d63b38e'

  def install
    bin.install 'scripts/run-in-container.sh' => 'rt'
    bin.install_symlink 'rt' => 'rti'
  end

  def caveats
    <<~EOS
      rt and rti require Docker.

        Install Docker: https://docs.docker.com/get-docker/

    EOS
  end

  test do
    assert_predicate bin / 'rt', :executable?
    assert_predicate bin / 'rti', :executable?
    assert_match 'docker', File.read(bin / 'rt')
  end
end
