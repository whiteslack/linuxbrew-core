class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.3.tar.gz"
  sha256 "34fcbc6bdc95c618a7903ca17434cfeb1ad12f0cdebbc75d35990975d37283b5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "9f45e84d2ca99fa5dc3db84b88da30b7be4764cca82ce40bac3515b392935f3c" => :catalina
    sha256 "245166bc2e16916f2d916b89ba9521c803538b4e9d8f598888ef4574e3888731" => :mojave
    sha256 "576a7e8472d4aa6ae60917618e785410d7ffce22d9560b1958f7243f88a0a374" => :high_sierra
    sha256 "52320bdfe84a195de7f9dda6f883a1b307066ebf12647381c2ccb66590f34068" => :x86_64_linux
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--with-iconv=#{sdk}/usr" if OS.mac?

    if OS.mac? && MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "clock_gettime(CLOCK_REALTIME, &tp);",
                             "undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
