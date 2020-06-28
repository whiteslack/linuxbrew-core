class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.2.1/stella-6.2.1-src.tar.xz"
  sha256 "47b991af880b1699614c081d602c197942cfbdcbf52e3d738617923d5df23dc7"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "905c36cc2c68968ffcedb83867474bd757f9b6188a9d49f7fd94d22f0e479b0d" => :catalina
    sha256 "482b97a5ebe760bb2793c95d0c51c3ac356417eb1c8479c4539086cc9ad203e9" => :mojave
    sha256 "ff69cdd3d5a5def9e99557b0d327e16da16b3b37298f769ec66bed2c0ff18003" => :high_sierra
    sha256 "5f698811afd8686eaa81b17158676e424682331fb0deedef0faff6a229a41dfe" => :x86_64_linux
  end

  depends_on :xcode => :build if OS.mac?
  depends_on "libpng"
  depends_on "sdl2"

  # Stella is using c++14
  unless OS.mac?
    fails_with :gcc => "5"
    fails_with :gcc => "6"
    fails_with :gcc => "7"
    depends_on "gcc@8"
  end

  uses_from_macos "zlib"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macos" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} /\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} /\* png)}, '//\1'
        s.gsub! /(HEADER_SEARCH_PATHS) = \(/,
                "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},"
        s.gsub! /(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);"
        s.gsub! /(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"'
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--with-sdl-prefix=#{sdl2.prefix}",
                          "--with-libpng-prefix=#{libpng.prefix}",
                          "--with-zlib-prefix=#{Formula["zlib"].prefix}"
    system "make", "install"
  end

  test do
    assert_match /Stella version #{version}/, shell_output("#{bin}/Stella -help").strip if OS.mac?
    # Test is disabled for Linux, as it is failing with:
    # ERROR: Couldn't load settings file
    # ERROR: Couldn't initialize SDL: No available video device
    # ERROR: Couldn't create OSystem
    # ERROR: Couldn't save settings file
  end
end
