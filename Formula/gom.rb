class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.4/gom-0.4.tar.xz"
  sha256 "68d08006aaa3b58169ce7cf1839498f45686fba8115f09acecb89d77e1018a9d"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "b8c298e1d442d15dd630bfe6b1edfeb11b77326b730237ffc4c6b3c607c48192" => :big_sur
    sha256 "ff2ac0dfef03bd08c7f03f13595af2e1476c396163e57066726c92e06cbe4fba" => :arm64_big_sur
    sha256 "c86f525462ffd97cb6bd469b5a26d1db56281d725916d5eb524f31a4750b1892" => :catalina
    sha256 "afda0dc772004cee3b8148719a078f6ac2871480260f310a5d06e367dcd68412" => :mojave
    sha256 "cccd9551ffced0a1648ff2f420eb3e5666ff102b4c81d96806cd7d25068ef7d7" => :high_sierra
    sha256 "a92aa28625e2fa471265d66e13887d4a79069e7770b04bd76bf19e28ed20f2f8" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpygobject-override-dir=#{lib}/python#{pyver}/site-packages", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
