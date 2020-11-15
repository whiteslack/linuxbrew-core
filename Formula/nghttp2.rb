class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.41.0/nghttp2-1.41.0.tar.xz"
  sha256 "abc25b8dc601f5b3fefe084ce50fcbdc63e3385621bee0cbfa7b57f9ec3e67c2"
  license "MIT"
  revision 1

  bottle do
    sha256 "f6174be18edb91cbe8fc53bbebcb9d2569df52af465c3e5f132fc1dd76ddb11d" => :big_sur
    sha256 "ae423161fb662dbd308578a9d20917392ee019878eb59e39779ab7e852b3fd21" => :catalina
    sha256 "2f79858dc2901da2c314468d39b07506f10c9d8f543a95308f8610f2f00888a4" => :mojave
    sha256 "34f66d7f13b502faa96a34cf936710ed8910e7d789d430eaeb452d011a0842df" => :high_sierra
    sha256 "1743f468597904c68823439dab39b70477122d3ee540924066d78ff2d218d0c5" => :x86_64_linux
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  unless OS.mac?
    patch do
      # Fix: shrpx_api_downstream_connection.cc:57:3: error:
      # array must be initialized with a brace-enclosed initializer
      url "https://gist.githubusercontent.com/iMichka/5dda45fbad3e70f52a6b4e7dfd382969/raw/" \
          "19797e17926922bdd1ef21a47e162d8be8e2ca65/nghttp2?full_index=1"
      sha256 "0759d448d4b419911c12fa7d5cbf1df2d6d41835c9077bf3accf9eac58f24f12"
    end
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --with-xml-prefix=/usr
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    # Fails on Linux:
    system "make", "check" if OS.mac?
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
