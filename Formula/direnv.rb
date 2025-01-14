class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.26.0.tar.gz"
  sha256 "b3dbb97f4d2627ec588894f084bfdc76db47ff5e3bec21050bb818608c7835b9"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32d8506f7eedfa4723b9b0acd06759e44e39ea29ec78eb94eba7022a613b192c" => :big_sur
    sha256 "5fba0c6d999b15cad35491431c49ed1b705713179b545bc524c8640be0d2eb8a" => :arm64_big_sur
    sha256 "931988a1192cd06480b0a3818a9732aad47b1d0a33d591fd5f0cc1edaebcff5d" => :catalina
    sha256 "4e1b4ac2a984bb63a895269c694ac2ac5259f4dc974525cad200d2b27c246f70" => :mojave
    sha256 "cf7a9c1a33f1044fe8014d8a858f36792f650351cce8798ae0c0cc7e6e3809f9" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
