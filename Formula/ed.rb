class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.16.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.16.tar.lz"
  sha256 "cfc07a14ab048a758473ce222e784fbf031485bcd54a76f74acfee1f390d8b2c"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0272fda8ecb6dd16a0d9b98701a1c2b039bb75eea93d0c423e16f0cfefde4e4a" => :big_sur
    sha256 "1c76956b9d0e923f6a93daf68fc9401c921e2fa534a6753fdad39483bfd04c7a" => :arm64_big_sur
    sha256 "c8ffa15f236faed29b760318f598903144a8f30ed6a09161f67578b9789760c9" => :catalina
    sha256 "2d8205eb80873325eb1b485238270df1d0e4ad71212d02f48dffbbdb77b529ed" => :mojave
    sha256 "57b85675d5c24f9fa076b9e115274f03c8ec136a36400956b488d6e11fb37e5c" => :high_sierra
    sha256 "097142ff8a9a39656648d9410269047249755173afa49999432ccdbc93f31270" => :x86_64_linux
  end

  keg_only :provided_by_macos

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", *("--program-prefix=g" if OS.mac?)
    system "make"
    system "make", "install"

    if OS.mac?
      %w[ed red].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      All commands have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"

    if OS.mac?
      pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read

      pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
      assert_equal "He word\n", testfile.read
    end

    unless OS.mac?
      pipe_output("#{bin}/ed -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read
    end
  end
end
