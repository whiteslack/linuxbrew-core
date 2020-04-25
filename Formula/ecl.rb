class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-20.4.24.tgz"
  sha256 "670838edf258a936b522fdb620da336de7e575aa0d27e34841727252726d0f07"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "2a33f32a5ae0e6f53cc341e2235525a5c5bdeaf1a696e19f1fdaf2b8c36bb02c" => :catalina
    sha256 "1cccfc0bb6405dc4c9515936ee14589837794b61738477bd72ba77d5e0fcc9e9" => :mojave
    sha256 "8b216d4e8eb3491593160a2d291beb13b228bc8442cc0c5d391c196754f8968c" => :high_sierra
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  # Fixes: ffi.d:136:28: error: FFI_SYSV undeclared here (not in a function)
  # https://gitlab.com/kiandru/nixpkgs/-/commit/00c3761322ec4d2aa85e66f1c55452ded3f9e681
  patch :p1, :DATA

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end

__END__
diff --git a/src/c/ffi.d b/src/c/ffi.d
index 8174977a..caa69f39 100644
--- a/src/c/ffi.d
+++ b/src/c/ffi.d
@@ -133,8 +133,8 @@ static struct {
 #elif defined(X86_WIN64)
   {@':win64', FFI_WIN64},
 #elif defined(X86_ANY) || defined(X86) || defined(X86_64)
-  {@':cdecl', FFI_SYSV},
-  {@':sysv', FFI_SYSV},
+  {@':cdecl', FFI_UNIX64},
+  {@':sysv', FFI_UNIX64},
   {@':unix64', FFI_UNIX64},
 #endif
 };

