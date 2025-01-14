class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.14.tar.gz"
  sha256 "f3ae8d3d4564a41b6e2a21f237d2f2b104f48108591e8b83497500182a3ab3a4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 4
    sha256 "e87da2b47386fc7e3c6f20b3ff90c4bbe37b9e0aaa884440ffa216492dbc150b" => :big_sur
    sha256 "8ac02041dbec3966b6a695dfc4215b90b9e331ae6eb8c6698cbbfa0175154c9f" => :arm64_big_sur
    sha256 "82e64b2008971430d160a3f564e32593e98fb55c43d7748c7deb9d6f546e1102" => :catalina
    sha256 "8ca49b4797277f79e87e48ab4c6794601b64d1dde35b9eac556d4153b8237a51" => :mojave
    sha256 "a3e2faaf2a2ca2bfbb787567f0fb43b8908522587b00b2e19b1e2d8b5f69fce8" => :x86_64_linux
  end

  pour_bottle? do
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX}."
    # https://github.com/Homebrew/brew/issues/2005
    satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
  end

  on_macos do
    # Software was last updated in 2007.
    # https://trac.macports.org/ticket/18255
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0ae366e6/a2ps/patch-contrib_sample_Makefile.in"
      sha256 "5a34c101feb00cf52199a28b1ea1bca83608cf0a1cb123e6af2d3d8992c6011f"
    end

    # https://trac.macports.org/ticket/20867
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0ae366e6/a2ps/patch-lib__xstrrpl.c"
      sha256 "89fa3c95c329ec326e2e76493471a7a974c673792725059ef121e6f9efb05bf4"
    end
  end

  on_linux do
    depends_on "gperf"
  end

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
