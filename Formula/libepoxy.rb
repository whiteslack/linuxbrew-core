class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.5.tar.xz"
  sha256 "261663db21bcc1cc232b07ea683252ee6992982276536924271535875f5b0556"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "667873f9c3ce190c398412dc2777628e4805f21cf29d4aac958aee93f82daaa7" => :big_sur
    sha256 "5384a83afdae256d771cb950907183f2ed2325ff0625d3a15247a4ec9f87036c" => :arm64_big_sur
    sha256 "2ff068dba2f188c30bc4e456e22a089f323c30d24dfa9df610d1515bf159d407" => :catalina
    sha256 "8263978cde00e743fef88e91afae02966e53e25e278aa0cea23aae648d1d11fa" => :mojave
    sha256 "2292151beaae8032dd84ead44e43d9f11a6d96173ba2eb0a33874b09a6842506" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  unless OS.mac?
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "xorgproto"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
