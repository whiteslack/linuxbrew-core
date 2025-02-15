class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.0/doxygen-1.9.0.src.tar.gz"
  sha256 "636bab2c3c85603302600ed9b95425717aee776e56a3215325fcce15bbfdaef6"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cb195e145b8f948f5bda842f1cfd75a12227f65c10380ba8fc4b4ab7410215c" => :big_sur
    sha256 "4190e7abd2b204272ef6b87cf3fb3f1b346e6bfd13d6e0e67c73f68b8ead8f1c" => :arm64_big_sur
    sha256 "d3e48b2eecd43fde1d0f3c2b599e429dc6fc0ad04b2da0586aef340c32c69c0c" => :catalina
    sha256 "4cc20518427bf8126923fb324451c82c70e052ecadc212242f54db41f563fc08" => :mojave
    sha256 "e55d7f97e146bb89ab0bb6be53846fa7d938367384b6396ba0911dd9f1d64c43" => :x86_64_linux
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
