class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.2/stella-6.2-src.tar.xz"
  sha256 "d45a7354513fa0d56a6290d1f3182f4c4e6621ab44228d829d923de535921410"
  head "https://github.com/stella-emu/stella.git"

  bottle do
    cellar :any
    sha256 "e074eb84ee736d9d79e2e335f3dd467c8a367e57e82047b273485f6cb396139f" => :catalina
    sha256 "df25eb2cd8f94d6574a0b2a3e0e776ba193afbbefd9882801b32712247cac681" => :mojave
    sha256 "8bd7aff3b2b8299058daa97a63d8a068389998ad7d0bd51a6715c85556679a2c" => :high_sierra
    sha256 "0a2eb7424a90159424728542e110579aebabb44d4e2b13ed102631d19d6739f2" => :x86_64_linux
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
