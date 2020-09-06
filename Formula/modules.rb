class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.3/modules-4.5.3.tar.bz2"
  sha256 "f6cd4ef29d5037d367d04fe041e06cc915a092afee664b56e1045ec74e66ac6b"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "cbc6ac501c2142c7919ecc9b56aa80d2e0828eb2c28060f792ab2d6da7947dec" => :catalina
    sha256 "5f21d6a67818b08d239fb5b530d2c82d097ea161ca17fd4b378fa63f4a50bf55" => :mojave
    sha256 "62863887e0df66d8fc99dd581a1949223d615d4bc58e4366bd0a086b42e8f94d" => :high_sierra
    sha256 "8a689a598702e785ea947b9cd3c8673eaa167f7cc182e37655cb04918d6c485f" => :x86_64_linux
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
