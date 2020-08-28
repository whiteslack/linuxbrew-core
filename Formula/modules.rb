class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.2/modules-4.5.2.tar.bz2"
  sha256 "9366a2c6230f7ce4b5861a0629db10867f39144e382d209681619fe273950655"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "a2ad130312c85f33d18a50e31c4461f3cee080169aa29e00481fc51a8353b3f3" => :catalina
    sha256 "055020e7d4050da4c501aab2aaf7c71e3999bf497558488ff02b877a029cf2e2" => :mojave
    sha256 "e7684dbd641f7aaaab506df008d1c4caa41aa73f1a28631a461e0c671d23f5d9" => :high_sierra
    sha256 "a8b3e48eb88ad665c145bd496f32af43787ea311c910e0c0867e2ea7c48895df" => :x86_64_linux
  end

  on_linux do
    depends_on "tcl-tk"
    depends_on "less"
  end

  def install
    tcl = OS.mac? ? "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk"].opt_lib
    with_tclsh = OS.mac? ? "" : "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    with_pager = OS.mac? ? "" : "--with-pager=#{Formula["less"].opt_bin}/less"

    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcl}
      #{with_tclsh}
      #{with_pager}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:
        source #{opt_prefix}/init/zsh
      You will also need to reload your .zshrc:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = if OS.mac?
      shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    else
      shell_output("sh -c '. #{prefix}/init/sh; module' 2>&1")
    end
    assert_match version.to_s, output
  end
end
