class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.50/vala-0.50.2.tar.xz"
  sha256 "2c0d5dc6d65d070f724063075424c403765ab7935c9e6fbcb84981b94d07ceda"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "6ff805a2341794a6ada8701ef3051b9eaca0a1fd3c96f946cb4b0540d02775ce" => :big_sur
    sha256 "1983937b2ed076a9bde97a76aad939bdbe8b93b04da9250e7a4ce862589e1c65" => :arm64_big_sur
    sha256 "bd10c0e3caa8ce6d1c2ca20143bc21dffd3eb6b82795fa85e0e03031a0ce02b2" => :catalina
    sha256 "a6a5a6dea8495b92690f942b180eb60569f718eb12303431634632600c316989" => :mojave
    sha256 "a47350f2d4a4e51d84a6e0ee9fb6802880f5a053fe7307c6e013c83fd0436fc9" => :x86_64_linux
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
