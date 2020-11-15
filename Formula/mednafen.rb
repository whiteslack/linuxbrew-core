class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.26.1.tar.xz"
  sha256 "842907c25c4292c9ba497c9cb9229c7d10e04e22cb4740d154ab690e6587fdf4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "1ad2bba5c312f2cd5396844c0674a1ed4de85916596d50a5f3c24a244776a6ed" => :catalina
    sha256 "0569f3945b958e2e7f65a09cac93b360ad56d8c58fed3da05f1771aed3f391a5" => :mojave
    sha256 "d0e98aafea519a145b92b3ffed0e218332d54834bbc69e272120250b081b50a0" => :high_sierra
    sha256 "c83ba082ffa83c8d2cd3bfc3ef514c03980eeaad7b5f59817dd516e48b9696db" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"

  uses_from_macos "zlib"

  unless OS.mac?
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if ENV["CI"]

    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
