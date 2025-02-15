class Dirac < Formula
  desc "General-purpose video codec aimed at a range of resolutions"
  homepage "https://sourceforge.net/projects/dirac/"
  url "https://downloads.sourceforge.net/project/dirac/dirac-codec/Dirac-1.0.2/dirac-1.0.2.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/dirac_1.0.2.orig.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dirac/dirac_1.0.2.orig.tar.gz"
  sha256 "816b16f18d235ff8ccd40d95fc5b4fad61ae47583e86607932929d70bf1f00fd"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "2d6aa7e4d9c73e1a79b9b23b86ade670324755806276d6061ec1b3e9f444548a" => :big_sur
    sha256 "fd13d2ad2ae2be488a3667d58a9ae207a12afe17826e6d8fdebf454bba4a543f" => :arm64_big_sur
    sha256 "8c4a433f067fac458d219eaed956744d84cb9069334df82a3745e6f5f24aa686" => :catalina
    sha256 "c018586bbfdeb10487adc1c62bdd74138b9d11195064bd2a07d458a55d770a06" => :mojave
    sha256 "9413ec8e068d4c8e30d679a62af9779a09de385e2287acebacf9e5c56e80a50a" => :high_sierra
    sha256 "09b846fe4069e971ec6d10668d97ac599cb555e5799f3ba3076d0d088e1f78cf" => :sierra
    sha256 "8f4414614755f863d3ba0f43d6415684fbc00976ae24c7e45c88fe736be918d2" => :el_capitan
    sha256 "1d3049d9dcdbd0116c65c54582601b20cdd17c8b89cf80e74efc79f71b641ca4" => :yosemite
    sha256 "e7c407545085631c27c77f2d15abe84b3cc0a3645cf5e538aa15f0aacfe6de50" => :mavericks
    sha256 "bcf101614a66678b18f442ea650f3ee58a813a1a2d15cb1655da65608bd90d3d" => :x86_64_linux
  end

  # First two patches: the only two commits in the upstream repo not in 1.0.2

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/da8a53abcf057c58b498/raw/bde69c5f07d871542dcb24792110e29e6418d2a3/unititialized-memory.patch"
    sha256 "d5fcbb1b5c9f2f83935d71ebd312e98294121e579edbd7818e3865606da36e10"
  end

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/e729c459525d0d6e9e2d/raw/d9ff69c944b8bde006eef27650c0af36f51479f5/dirac-gcc-fixes.patch"
    sha256 "52c40f2c8aec9174eba2345e6ba9689ced1b8f865c7ced23e7f7ee5fdd6502c3"
  end

  # HACK: the configure script, which assumes any compiler that
  # starts with "cl" is a Microsoft compiler
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/dirac/1.0.2.patch"
    sha256 "8f77a8f088b7054855e18391a4baa5c085da0f418f203c3e47aad7b63d84794a"
  end

  def install
    # BSD cp doesn't have '-d'
    inreplace "doc/Makefile.in", "cp -dR", "cp -R"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
