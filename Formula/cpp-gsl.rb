class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v3.0.0.tar.gz"
  sha256 "767b6246eecd0b2a915e2b5774ba6d4796579a5e15dc562d93ec80f1f2c9c889"
  head "https://github.com/Microsoft/GSL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "abe62b73d3f81dab4d99bafc5dfdcc3b2640e81114b9bb43d9209af6e95d83dc" => :catalina
    sha256 "abe62b73d3f81dab4d99bafc5dfdcc3b2640e81114b9bb43d9209af6e95d83dc" => :mojave
    sha256 "abe62b73d3f81dab4d99bafc5dfdcc3b2640e81114b9bb43d9209af6e95d83dc" => :high_sierra
    sha256 "62089d67c8bc1ad14e472b21997dbc6bf1c8dab731c964c57775425c0c8b820a" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DGSL_TEST=false", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
