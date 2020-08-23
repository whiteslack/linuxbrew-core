class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_12.1.7.tar.xz"
  sha256 "4d3d01e1793a35b1122d0dd00933002c383532d5708916d55594a3a1e9ea0723"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "libbsd"
  depends_on :linux
  depends_on "ncurses"

  def install
    File.open("debian/patches/series") do |file|
      file.each { |patch| system "patch -p1 <debian/patches/#{patch}" }
    end
    inreplace "Makefile", "/usr/", "#{prefix}/"
    inreplace "config.mk", "/usr/", "#{prefix}/"
    system "make", "install"
  end

  test do
    system "#{bin}/cal"
  end
end
