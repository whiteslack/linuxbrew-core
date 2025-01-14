class Jrtplib < Formula
  desc "Fully featured C++ Library for RTP (Real-time Transport Protocol)"
  homepage "https://research.edm.uhasselt.be/jori/jrtplib"
  url "https://research.edm.uhasselt.be/jori/jrtplib/jrtplib-3.11.2.tar.bz2"
  sha256 "2c01924c1f157fb1a4616af5b9fb140acea39ab42bfb28ac28d654741601b04c"

  livecheck do
    skip "No longer developed"
  end

  bottle do
    cellar :any
    sha256 "c025524ef889d74cc261768b9e12f8d3ffe57802adef254e2a01850db983e269" => :big_sur
    sha256 "b00a6b5d09b1eb5d8e6a72e548cff53f2834b4b07d235f3cb4ee346b9d4a0dbc" => :arm64_big_sur
    sha256 "05fc5e0747f7d5f725f9dda22cf39d414e8ee751829d14e9c32fa12279834cfc" => :catalina
    sha256 "1b48b36e9011b4aa675f1d581e900c64bcad93ba15fc86d1e27db09ed2c75ce9" => :mojave
    sha256 "420016bd3f9981189dc8bf69dc7520da8d9cbde848147dde495792c1a5a984fa" => :high_sierra
    sha256 "43260e27fd5b6abdd0b2ed5d7a6628a490a6fd7dd0e492a731e30fb117c22384" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jthread"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <jrtplib3/rtpsessionparams.h>
      using namespace jrtplib;
      int main() {
        RTPSessionParams sessionparams;
        sessionparams.SetOwnTimestampUnit(1.0/8000.0);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ljrtp",
                    "-o", "test"
    system "./test"
  end
end
