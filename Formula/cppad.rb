class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20200000.3.tar.gz"
  sha256 "b37f3bc13d1e653828fefec604260d93224dc66a5f70da5500bc7bf2ba13c3d3"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eaf51d282b9812ddc697f9e606e6f17b2a728f5b670885c8dc0e26f2b2f896a1" => :big_sur
    sha256 "a9baa4f60725d18c5f7cbb244f47c9a4af645012ad5e21889b43f0d1272d0357" => :arm64_big_sur
    sha256 "4ef0d734cddee5d7dfde8398b8b295cc35100424639db041816459636de3087f" => :catalina
    sha256 "948e5a9ae91c50297d528c87b1f38afcd15f4e6b6f162ce7ddffa2f43b329143" => :mojave
    sha256 "d74b4ab769dccd4537ef03dd28fea858b81ee2938df776e5d45a23069c57c142" => :high_sierra
    sha256 "3f24f827195344fe1e1a9eca220cca50b3a7417553c1e4d6ffce7f9ed46e9b96" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end
    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
