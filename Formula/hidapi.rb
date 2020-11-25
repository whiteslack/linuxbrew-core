class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.10.1.tar.gz"
  sha256 "f71dd8a1f46979c17ee521bc2117573872bbf040f8a4750e492271fc141f2644"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git"

  bottle do
    cellar :any
    sha256 "98f2859ea147e9c92e4925f0887062c8b6f5177eb98a1012b95d3b788cb58ea5" => :big_sur
    sha256 "9287809ecfeaeb3c89b1f9bf8babb31a8971b41c4a9795922ab774bfcc66559d" => :catalina
    sha256 "e9c2bec30d5d1e9e0f9f91c43510071ba17234cd968b33f161c56cbee23a4d8d" => :mojave
    sha256 "76255d24660fc5a7d70c363b7bfd5c3896a166276dbd6620e61d13105baf54b9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "systemd" # for libudev
    depends_on "libusb"
  end

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    # hidtest/.libs/hidtest does not exist for Linux, do not install it
    bin.install "hidtest/.libs/hidtest" if OS.mac?
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}", OS.mac? ? "-lhidapi" : "-lhidapi-hidraw"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
