class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"

  bottle do
    sha256 "06ce12b4caedfc807687c9ab8d2fdacf6a4dd7a26299a2bc6039a690d380e27f" => :big_sur
    sha256 "77dcfaf55565b5d34f1ca0da75bc7aed7cdbb9b66ba684147ada21421f35005b" => :catalina
    sha256 "176548e1d698baf5187088bf16b273af3e3e585f5f765963c396187491ea5fe1" => :mojave
    sha256 "3c12f59317ded4bdc6f89c24a0eec9260a499371c9c92b2d5e34c1b1a9f50a2c" => :high_sierra
    sha256 "ad941124a4952ebc353f03601d3da5670155a1eb8271e290bc96b0a54ec87e9e" => :sierra
    sha256 "4243dd63fc3decf1f529e86fd19897a2e4311f9d91ebfc812ceeec13cab9149a" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "expat"
  uses_from_macos "texinfo"

  unless OS.mac?
    patch :p1 do
      url "https://github.com/Unidata/UDUNITS-2/commit/0bb56200221ad960bc2da11fc0b4a70ec3c5d7c9.patch?full_index=1"
      sha256 "8b84fabe21d2da252e6bdd2dd514230d73579ca034d4d83e42f40527dc72fe0c"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
