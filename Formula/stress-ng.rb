class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.16.tar.xz"
  sha256 "38accf36c4c30a51668fed8f5da4d8b097918046ee6567dc3f81b55039fd2454"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "01fef2c66d2c1cbd73ba197a1b3156d708c6ae0138b058f350c16fe3a66e6f4d" => :catalina
    sha256 "9a08087727f24c7d11c11b154dd6194d663dd49262047ce24ec8d7433bd17cbf" => :mojave
    sha256 "2beb7847394f25cd382da5ede362eaa50d961c1534c25cded2ce07e7ab25ba7c" => :high_sierra
    sha256 "63db366d084d7145945b0a7b25cf246be852f8d001261bcbdaefd2f9453df61a" => :x86_64_linux
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on :macos => :sierra
  end

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
