class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.7.0/datetime-fortran-1.7.0.tar.gz"
  sha256 "cff4c1f53af87a9f8f31256a3e04176f887cc3e947a4540481ade4139baf0d6f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "13b551703e1afcdcb1c4a92939afdce7447fbf96e071c984944a8bee8e833496" => :big_sur
    sha256 "e2986c9fde31f0bb075f4399c251599b481e2c9f5509e9ba6aa56e2fd8f2c939" => :arm64_big_sur
    sha256 "82d8b0e2a51fb7df321659ed4f5da43c24edd5aba81e5e05250508b541f2eb4b" => :catalina
    sha256 "ef59feabc30610c41a5ac4b2e594f1378d3edeb3b13dd7912825c48815d547e2" => :mojave
    sha256 "cf59b21c0539aa14f5e0274387669d13dae47b3e11267cdb1baed8545f2bd535" => :high_sierra
    sha256 "feb4d7b3d80d6171b60cbaeef71edddc00a6b65467d24750bc4d583f6fd8ad3d" => :x86_64_linux
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-I#{include}", pkgshare/"test/datetime_tests.f90",
                       "-L#{lib}", "-ldatetime", "-o", "test"
    system "./test"
  end
end
