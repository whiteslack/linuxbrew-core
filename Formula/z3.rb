class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.9.tar.gz"
  sha256 "c9fd04b9b33be74fffaac3ec2bc2c320d1a4cc32e395203c55126b12a14ff3f4"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git"

  livecheck do
    url "https://github.com/Z3Prover/z3/releases/latest"
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "ec93e6adf6c98ad275de3aa4c2b81dc28e73d3b5dabf09f00ad0331bc477c196" => :catalina
    sha256 "6d8fe5edae3dbffef24fc3e65c5102a4d58a5ef62594a508f2042bec068b10a1" => :mojave
    sha256 "1ef6ec089f5a3b42b9e9be906ddb99d7538984b58310051acc90e2a92af4146c" => :high_sierra
    sha256 "5cc8b7222171bcca8c474dc00511da632974af92c341730606a3d09241524bb8" => :x86_64_linux
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.8" => :build

  def install
    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{lib}/python#{xy}/site-packages",
                     "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c",
      "-I#{include}", "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
  end
end
