class Avra < Formula
  desc "Assembler for the Atmel AVR microcontroller family"
  homepage "https://github.com/hsoft/avra"
  url "https://github.com/hsoft/avra/archive/1.4.2.tar.gz"
  sha256 "cc56837be973d1a102dc6936a0b7235a1d716c0f7cd053bf77e0620577cff986"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1b6077185e775675dfd538ee67fab94c5e24219dd8cd76b1dbc962748572513" => :big_sur
    sha256 "22a03e978b90b0c87a7a7d15f63975880a8bad314c2592bf107b7bcb3d5fe5c6" => :arm64_big_sur
    sha256 "752edb7e9140387d4b763229ff05cdf973056a70c5a4799b63cce83c2ff18be5" => :catalina
    sha256 "cedf5547712134c47d3659e1cddde7d506643448eca98fb428734165fbb5afc7" => :mojave
    sha256 "f380ed5ddc18ece7b83f4c32290f56dfcc8a27065cc1a39423debfc482d369d2" => :high_sierra
    sha256 "890cfef31d511f8fc163505af866e664315e26cf2b5bbcd6c806ab8daa0359b5" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "OS=osx"
    pkgshare.install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert_predicate testpath/"test.hex", :exist?
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
