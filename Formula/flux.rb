class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.95.0",
      revision: "2e0f9dd8dbf9417d7f83010a3912ded9a61e7237"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url "https://github.com/influxdata/flux/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "1fe90ac54ecbc345199084e5668849ba17ab8356252dcca685b1c16d94edb31e" => :big_sur
    sha256 "689eed4de5fedb95de3bb039d50278c727df292d43238cc455bd912a308451f1" => :catalina
    sha256 "0cccaeb72e45422749d77e630a6e123c45c6b71595e9213d5e36836f9630e9f3" => :mojave
    sha256 "2150b8a4cc9798de3e77fe8eca34c5487920cb9b28210b67872701bb1569f1a9" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    on_macos do
      lib.install "libflux/target/x86_64-apple-darwin/release/libflux.dylib"
      lib.install "libflux/target/x86_64-apple-darwin/release/libflux.a"
    end
    on_linux do
      lib.install "libflux/target/x86_64-unknown-linux-gnu/release/libflux.so"
      lib.install "libflux/target/x86_64-unknown-linux-gnu/release/libflux.a"
    end
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
