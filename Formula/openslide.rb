class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  license "LGPL-2.1-only"
  revision 5

  bottle do
    cellar :any
    sha256 "5cc9273868f2816ac3b2cfd9d12bcbc44d68fb461000469896c4f10b8047511f" => :big_sur
    sha256 "bcff20f6ae95b56179cd6c9d2a6f2f94672d499ba69283f7f3cd83ce70a51873" => :arm64_big_sur
    sha256 "6b59207518417bb5a45a716d6c26a01ed8d9977af51992b00d0479a7d9a4ffae" => :catalina
    sha256 "d90e3ee5514064389cea2bdf1d4369cc2be4e1d965ac9d56f47e0c6e22f310af" => :mojave
    sha256 "1d70f22fad80e061bcfa5d4955d522d37bd077c51cad4697579a104759233ad2" => :high_sierra
    sha256 "de34071d033c87c731be7954d7c0ced87ddf086100c29fea07410d68621b9929" => :sierra
    sha256 "421b9ef84c0d9ee17356a47208e6b8ad07f83d5c944855a4f3b6bb7fe2f64a40" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openjpeg"

  resource "svs" do
    url "http://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
