class LibnetfilterQueue < Formula
  desc "Userspace API to packets queued by the kernel packet filter"
  homepage "https://www.netfilter.org/projects/libnetfilter_queue"
  url "git://git.netfilter.org/libnetfilter_queue",
    tag:      "libnetfilter_queue-1.0.5",
    revision: "2ff321690b8dafeca99ee8e9cafac71e36f292b9"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmnl"
  depends_on "libnfnetlink"
  depends_on :linux

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <errno.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <string.h>
      #include <time.h>
      #include <arpa/inet.h>

      #include <libmnl/libmnl.h>
      #include <linux/netfilter.h>
      #include <linux/netfilter/nfnetlink.h>

      #include <linux/types.h>
      #include <linux/netfilter/nfnetlink_queue.h>

      #include <libnetfilter_queue/libnetfilter_queue.h>

      int main(int argc, char *argv[])
      {
        struct mnl_socket *nl;
        char buf[NFQA_CFG_F_MAX];
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
