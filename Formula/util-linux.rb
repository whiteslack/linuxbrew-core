class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.1.tar.xz"
  sha256 "09fac242172cd8ec27f0739d8d192402c69417617091d8c6e974841568f37eed"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]

  bottle do
    rebuild 1
    sha256 "d3ca947d64da7e1a090f6747bcfacda7ba4059ad5b716d2560778aab08a26b41" => :big_sur
    sha256 "7a2842abe7cffd1a4d40e7cda3284bb6d1a8960d4a7f528c131bd3a7916efa2b" => :catalina
    sha256 "dd4bfa3e3ffc8b3106e55c8fa52350130d7a7616bb65eb64fb8f8b9492fc9765" => :mojave
  end

  keg_only "macOS provides the uuid.h header" if OS.mac?

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # These binaries are already available in macOS
  def system_bins
    %w[
      cal col colcrt colrm
      getopt
      hexdump
      logger look
      mesg more
      nologin
      renice rev
      ul
      whereis
    ]
  end

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    if OS.mac?
      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-libmount" # does not build on macOS
      args << "--enable-libuuid" # conflicts with ossp-uuid
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
      args << "--disable-cal" # Conflicts with bsdmainutils
      args << "--without-systemd" # Do not install systemd files
      args << "--with-bashcompletiondir=#{bash_completion}"
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system "./configure", *args
    system "make", "install"

    if OS.mac?
      # Remove binaries already shipped by macOS
      system_bins.each do |prog|
        rm_f bin/prog
        rm_f sbin/prog
        rm_f man1/"#{prog}.1"
        rm_f man8/"#{prog}.8"
      end
    else
      # these conflict with bash-completion-1.3
      %w[chsh mount rfkill rtcwake].each do |prog|
        rm_f bash_completion/prog
      end
    end

    # install completions only for installed programs
    Pathname.glob("bash-completion/*") do |prog|
      if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
        # these conflict with bash-completion on Linux
        next if !OS.mac? && %w[chsh mount rfkill rtcwake].include?(prog.basename.to_s)

        bash_completion.install prog
      end
    end
  end

  def caveats
    linux_only_bins = %w[
      addpart agetty
      blkdiscard blkzone blockdev
      chcpu chmem choom chrt ctrlaltdel
      delpart dmesg
      eject
      fallocate fdformat fincore findmnt fsck fsfreeze fstrim
      hwclock
      ionice ipcrm ipcs
      kill
      last ldattach losetup lsblk lscpu lsipc lslocks lslogins lsmem lsns
      mount mountpoint
      nsenter
      partx pivot_root prlimit
      raw readprofile resizepart rfkill rtcwake
      script scriptlive setarch setterm sulogin swapoff swapon switch_root
      taskset
      umount unshare utmpdump uuidd
      wall wdctl
      zramctl
    ]
    on_macos do
      <<~EOS
        The following tools are not supported for macOS, and are therefore not included:
        #{Formatter.columns(linux_only_bins)}
        The following tools are shipped by macOS, and are therefore not included:
        #{Formatter.columns(system_bins)}
      EOS
    end
  end

  test do
    stat  = File.stat "/usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, ((stat.mode & (2 ** index)).zero? ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end
