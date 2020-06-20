class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.6.3",
      :revision => "1e8c62baad31c829c5993235c429248f36a85478"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d8a3349751f06f8b9abca029719b9d3ce5bd475adb949d61efe97432dce12b5" => :catalina
    sha256 "4d8a3349751f06f8b9abca029719b9d3ce5bd475adb949d61efe97432dce12b5" => :mojave
    sha256 "4d8a3349751f06f8b9abca029719b9d3ce5bd475adb949d61efe97432dce12b5" => :high_sierra
    sha256 "e13f3d9d38443d4e761a809fe20c48ebec5a6a7f982c80c0965b99356b68c262" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
