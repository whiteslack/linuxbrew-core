class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1.2.9/libtorrent-rasterbar-1.2.9.tar.gz"
  sha256 "6c986225a1c2d9eb23c5b1ac0692d83208b721a05c968102a17ee3fde01bd709"
  license "BSD-3-Clause"

  livecheck do
    url :head
    regex(/^libtorrent[._-]v?(\d+(?:[-_.]\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "0e6895cc08dbd61dfa24beaa432285b23625c57a2630a7ae0a8ea88bd2b8ed57" => :catalina
    sha256 "2f75ce87ec73177d32caff6f534f433614196884ebef8932b92a55b615097be8" => :mojave
    sha256 "9b82b726e6b422bd00f8e6513f99d7e4df86731d4f119ba2abfeba770803002b" => :high_sierra
    sha256 "0dd0baee278db79bfd78bb2b2e1ddc0a47d8680f0a0c99e0440934df70d3cf36" => :x86_64_linux
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    pyver = Language::Python.major_minor_version(Formula["python@3.8"].bin/"python3").to_s.delete(".")
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python#{pyver}-mt
      PYTHON=python3
      PYTHON_EXTRA_LIBS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --libs --embed`.chomp}
      PYTHON_EXTRA_LDFLAGS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --ldflags`.chomp}
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"

    rm Dir["examples/Makefile*"]
    libexec.install "examples"
  end

  test do
    if OS.mac?
      system ENV.cxx, "-std=c++11", "-I#{Formula["boost"].include}/boost",
                      "-L#{lib}", "-ltorrent-rasterbar",
                      "-L#{Formula["boost"].lib}", "-lboost_system",
                      "-framework", "SystemConfiguration",
                      "-framework", "CoreFoundation",
                      libexec/"examples/make_torrent.cpp", "-o", "test"
    else
      system ENV.cxx, libexec/"examples/make_torrent.cpp",
                      "-std=c++11",
                      "-I#{Formula["boost"].include}/boost", "-L#{Formula["boost"].lib}",
                      "-I#{include}", "-L#{lib}",
                      "-lpthread",
                      "-lboost_system",
                      "-ltorrent-rasterbar",
                      "-o", "test"
    end
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
