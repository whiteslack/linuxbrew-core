class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.1.2.tar.gz"
  sha256 "3af7b4cfd572c67275ad24fea31bcf9d9f365ec16a1b7e90d4bde930936707f3"

  bottle do
    cellar :any
    sha256 "4600e04403f227ce18b789e236dc78faf8fd9ba230c99ba71e1e011bf33d21d8" => :catalina
    sha256 "7f99040c5cb0cb12dec832043fc3789b30e323ee3759cea291b8783caa48e43a" => :mojave
    sha256 "4016b954fb4052fd8988cfbd569c32ae8700f1c5b3da60eaf576672545f18df2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on "postgresql"

  unless OS.mac?
    depends_on "doxygen" => :build
    depends_on "xmlto" => :build
    depends_on "gcc@9"
    fails_with :gcc => "5"
    fails_with :gcc => "6"
    fails_with :gcc => "7"
    fails_with :gcc => "8"

    # Remove with next release
    patch :DATA
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
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
__END__
diff --git a/config/Makefile.in b/config/Makefile.in
index 43a46b15d73dc57c9cb2004390ade522b61734b9..c5ce52c0f028bb703a4f64cf21b00e812fd3eee1 100644
--- a/config/Makefile.in
+++ b/config/Makefile.in
@@ -123,7 +123,7 @@ am__can_run_installinfo = \
   esac
 am__tagged_files = $(HEADERS) $(SOURCES) $(TAGS_FILES) $(LISP)
 am__DIST_COMMON = $(srcdir)/Makefile.in compile config.guess \
-	config.sub install-sh ltmain.sh missing mkinstalldirs
+	config.sub depcomp install-sh ltmain.sh missing mkinstalldirs
 DISTFILES = $(DIST_COMMON) $(DIST_SOURCES) $(TEXINFOS) $(EXTRA_DIST)
 ACLOCAL = @ACLOCAL@
 AMTAR = @AMTAR@
diff --git a/include/Makefile.am b/include/Makefile.am
index c7eec4f5b969108193a892ba1a47c763669b917f..bde8429c6c4169b252f1eea21b8a29a25dff4043 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -60,9 +60,7 @@ nobase_include_HEADERS= pqxx/pqxx \
 	pqxx/internal/gates/result-pipeline.hxx \
 	pqxx/internal/gates/result-sql_cursor.hxx \
 	pqxx/internal/gates/transaction-sql_cursor.hxx \
-	pqxx/internal/gates/transaction-transactionfocus.hxx \
-	pqxx/internal/ignore-deprecated-pre.hxx \
-	pqxx/internal/ignore-deprecated-post.hxx
+	pqxx/internal/gates/transaction-transactionfocus.hxx
 
 
 nobase_nodist_include_HEADERS = \
diff --git a/include/Makefile.in b/include/Makefile.in
index def20f2105a2aeae0bdbe16aea6d733a6bf6c183..737b3cc1d77e0bfbed04278820db22768ac2cd9c 100644
--- a/include/Makefile.in
+++ b/include/Makefile.in
@@ -410,9 +410,7 @@ nobase_include_HEADERS = pqxx/pqxx \
 	pqxx/internal/gates/result-pipeline.hxx \
 	pqxx/internal/gates/result-sql_cursor.hxx \
 	pqxx/internal/gates/transaction-sql_cursor.hxx \
-	pqxx/internal/gates/transaction-transactionfocus.hxx \
-	pqxx/internal/ignore-deprecated-pre.hxx \
-	pqxx/internal/ignore-deprecated-post.hxx
+	pqxx/internal/gates/transaction-transactionfocus.hxx
 
 nobase_nodist_include_HEADERS = \
 	pqxx/config-public-compiler.h
