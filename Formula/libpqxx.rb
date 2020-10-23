class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.2.0.tar.gz"
  sha256 "c482a31c5d08402bc9e8df8291bed3555640ea80b3cb354fca958b1b469870dd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "06603e0e6c8b28697c1dbce085ab9af400d017234f248ba05d43bc9189c63339" => :catalina
    sha256 "a272c30a9b459e5fb2b98448a37cb625db71f55334d69c56534c7083fb013eda" => :mojave
    sha256 "420ebd77efbe086f93efb2aac4794de96eeb9e6ef09dd0451f2e254ebcf0e4fd" => :high_sierra
    sha256 "1a47a449cd0e6089f65cf58b0864e6cf2c6ae77088a209dcf93cb755ffeb6cda" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on "postgresql"

  unless OS.mac?
    depends_on "doxygen" => :build
    depends_on "xmlto" => :build
    depends_on "gcc@9"
    fails_with gcc: "5"
    fails_with gcc: "6"
    fails_with gcc: "7"
    fails_with gcc: "8"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    cxx = OS.mac? ? ENV.cxx : Formula["gcc@9"].opt_bin/"g++-9"

    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
