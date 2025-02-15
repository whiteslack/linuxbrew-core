class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "https://shmcat.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.9.tar.xz"
  sha256 "831f1671e737bed31de3721b861f3796461ebf3b05270cf4c938749120ca8e5b"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/shmcat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4a7b108892ada071d5ce75b8eb434b9c77c6cea5ed767ce31c78ac6e4b90d540" => :big_sur
    sha256 "3bdee0944414bc51a08a7707e29d16a6f08e1d583ad4cd8357587da2a6519d05" => :arm64_big_sur
    sha256 "f86090c36d839092913667dcfc924f76c71d318a03434a1e608b3960b1df7807" => :catalina
    sha256 "e052a4f6b21407c032c1ee5a79fe9b1c08e78b7980c1cd3d6bfbfa8ffe639a58" => :mojave
    sha256 "ff73e6df8b663b4f382098ce75a9ec4634d4658c5378b3ad122de135e30d44ab" => :high_sierra
    sha256 "5ee7bcafe69d653421e29b56cf2e48a55874dc1e092e817a83cb446cda4acf01" => :sierra
    sha256 "1b6ddaf528253df2e2d5b93e97b6f4ade717ff8f3f6bcf829ed7cf9d9e682539" => :el_capitan
    sha256 "ba5d4d130846537f603b399ea5896daf4125b0d19bd143a130c0b68a4006acee" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-ftok",
                          "--disable-nls"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/shmcat --version")
  end
end
