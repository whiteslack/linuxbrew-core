class DeviceMapper < Formula
  desc "Device mapper userspace library and tools"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/git/lvm2.git",
    tag:      "v2_03_10",
    revision: "4d9f0606beb0acb329794909560433c08b50875d"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "libaio"
  depends_on :linux

  def install
    # https://github.com/NixOS/nixpkgs/pull/52597
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-pkgconfig"
    system "make", "device-mapper"
    system "make", "install_device-mapper"
  end
end
