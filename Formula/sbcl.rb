class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.5.8/sbcl-1.5.8-source.tar.bz2"
  sha256 "84572f9133d13c982db13d1768d38331421204bc0ca083dacc5364e46796ff4c"

  bottle do
    sha256 "60bf72c89733113da85122a33183543ca0945a96a1131b4a1a8c6a1fdf6a946d" => :catalina
    sha256 "5196d16f387c8a3d3bfffd1a3cb360c7ea55f5d4276ca092a8201552ca9a2c8d" => :mojave
    sha256 "edd01cc279932be0dd7912f7a43e136eb6c55ca03566c09c09d1e0f0b2f0776b" => :high_sierra
  end

  uses_from_macos "zlib"

  # Current binary versions are listed at https://sbcl.sourceforge.io/platform-table.html
  resource "bootstrap64" do
    if OS.mac?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.11/sbcl-1.2.11-x86-64-darwin-binary.tar.bz2"
      sha256 "057d3a1c033fb53deee994c0135110636a04f92d2f88919679864214f77d0452"
    elsif OS.linux?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.3.3/sbcl-1.3.3-x86-64-linux-binary.tar.bz2"
      sha256 "e8b1730c42e4a702f9b4437d9842e91cb680b7246f88118c7443d7753e61da65"
    end
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c5ffdb11/sbcl/patch-make-doc.diff"
    sha256 "7c21c89fd6ec022d4f17670c3253bd33a4ac2784744e4c899c32fbe27203d87e"
  end

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap64")

    command = "#{tmpdir}/src/runtime/sbcl"
    core = "#{tmpdir}/output/sbcl.core"
    xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files(libexec/"bin", :SBCL_SOURCE_ROOT => pkgshare/"src")
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
