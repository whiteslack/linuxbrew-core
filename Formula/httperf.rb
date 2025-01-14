class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  license "GPL-2.0"
  revision 2

  # Until the upstream GitHub repository creates a new release (something after
  # 0.9.0), we're unable to create a check that can identify new versions.
  livecheck do
    skip "No version information available to check"
  end

  bottle do
    cellar :any
    sha256 "5c8f3e33c44d4d705ea1e23663ac922cc61019299787defcf60df6161608a5de" => :big_sur
    sha256 "2628055d8209f52ee35bd325c155bb506c36b581fa697d013f6fe32ed6ab0b2f" => :arm64_big_sur
    sha256 "80a2634adda8fe39ebda84ccdf6cbbb0357668da3615067b6f9714229801d085" => :catalina
    sha256 "390d46278c9e7bd0f58003ba49bc1a0ab110ab24864029d6ae9fd8d3f491b57c" => :mojave
    sha256 "5c049e4bfc272313e7c1051da7430bc09e712d5a70f1593c5ecf08ac94b3b238" => :high_sierra
    sha256 "015d2ce99b57fa808ae284f44904ca209e11603bf66085bf64a8270c45203490" => :sierra
    sha256 "6e2c233325a56d3f77a7077072a6cbc2bb2027ff69cfea7cb2a16a4c7b2cac52" => :x86_64_linux
  end

  head do
    url "https://github.com/httperf/httperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  # Upstream patch for OpenSSL 1.1 compatibility
  # https://github.com/httperf/httperf/pull/48
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/httperf/openssl-1.1.diff"
    sha256 "69d5003f60f5e46d25813775bbf861366fb751da4e0e4d2fe7530d7bb3f3660a"
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/httperf", "--version"
  end
end
