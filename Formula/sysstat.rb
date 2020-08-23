class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/v12.4.0.tar.gz"
  sha256 "1962ed04832d798f5f7e787b9b4caa8b48fe935e854eef5528586b65f3cdd993"
  head "https://github.com/sysstat/sysstat.git"

  bottle do
  end

  depends_on :linux

  def install
    system "./configure",
      "--disable-file-attr", # Fix install: cannot change ownership
      "--prefix=#{prefix}",
      "conf_dir=#{etc}/sysconfig",
      "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    system "#{bin}/sar", "-V"
  end
end
