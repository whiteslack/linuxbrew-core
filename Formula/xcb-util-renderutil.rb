class XcbUtilRenderutil < Formula
  desc "Convenience functions for the X Render extension"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2"
  sha256 "c6e97e48fb1286d6394dddb1c1732f00227c70bd1bedb7d1acabefdd340bea5b"
  license all_of: ["X11", "HPND-sell-variant"]

  bottle do
    cellar :any
    sha256 "0941200260ef409b5daa61664cad100fe69b08e99b8cb440297079387e2dadff" => :big_sur
    sha256 "7091c73aa3571aa8c4cc2568175f91b3dffe7714dbb1ab334c86da174395d2e1" => :arm64_big_sur
    sha256 "5fb7ef030a443af89504e74d04fccf3000ac04bf152798e7d4242247e2378ae2" => :catalina
    sha256 "b0a2c992673650129ee49fcb4fbe6873ef4b8d29a5677ae873a27e05fc7a0d27" => :mojave
    sha256 "2fe0a7c790b83b5ea49327a59db0af06e02cd11981f693f08c34c0f56733e3a6" => :x86_64_linux
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-render-util.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-renderutil")
  end
end
