class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.6.0/modules-4.6.0.tar.bz2"
  sha256 "616f994384adf4faf91df7d8b7ae2dab5bad20d642509c1a8e189e159968f911"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "d424799ee3a971d0330ac8247782fd8a3c2fc6ddbf40c743249d643128bf8c9e" => :catalina
    sha256 "fbe7043ec34d578b42ab10dba769b594d19c9d5665b1f27060fdd3a8982cefcd" => :mojave
    sha256 "688cc5ba060e509134a35d057077c022b2e9d5451e988b46c239dde24934e5f7" => :high_sierra
    sha256 "8f1aa1146b9615fa333f98c0d8083ba45f0cfcdcbc2a4b5395bcd34cbf6ddf5a" => :x86_64_linux
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
