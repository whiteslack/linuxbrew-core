class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.18.tar.gz"
  sha256 "fa56dd08649f51b173017911cae277dc4b2c98211721c2a60708bf1d28839922"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "37ce4eac19eaa6e7111d7ef7897595ac71ebb58f6d7da32dc309bb02bc5a90b4" => :big_sur
    sha256 "4e6bdd57047af524d3efd157858a47d857a12fc110142a3d94bd47c8552fdc0a" => :arm64_big_sur
    sha256 "ff92eb820b2efae9e87e42491a590601f400160f27ea2804b176b02b1648be66" => :catalina
    sha256 "2700f31ebcc1e2ba9219d6b6ac040846eba21ccc25baca4fea8b7d630b6673d2" => :mojave
    sha256 "842ba6bbe666302bd39c1cf7d29caa7d5180c20757b8dfe91b99d3fe1d3da841" => :high_sierra
    sha256 "15a0c084a7f3a8a830201b4de92c6e250a155fc49546d8dffc003dedead98630" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tnef", "--version"
  end
end
