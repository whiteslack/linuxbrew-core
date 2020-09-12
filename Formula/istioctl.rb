class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.1",
      revision: "4e26c697ce460dc8d3b25b25818fb0163ca16394"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "40417e64c1a6f864aaa256dd76c31aed65623be7c6b15e6d0808382f7e73a557" => :catalina
    sha256 "75dff65ccf186e8dae4d9a217619add0a82524bf74198abf12377041f28a8d42" => :mojave
    sha256 "49fcc2f4f66e99e9b8341c6fc4616c0cd4341222ad1447ff2368c9028b58b68b" => :high_sierra
    sha256 "6b356f3ecaf450fe80e7aea0e73173626a125d08456038e9125de6fcc1750fcb" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
