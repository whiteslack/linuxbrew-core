class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.14.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.14.tar.xz"
  sha256 "9152596f244d26d250afed878adfe1d42f82fb87c61c5cba230e00fc34c67383"

  bottle do
    cellar :any_skip_relocation
    sha256 "236779ca51f0503bc80da88ef43433976361d779ac851a5f65220b6ca84e7f44" => :catalina
    sha256 "236779ca51f0503bc80da88ef43433976361d779ac851a5f65220b6ca84e7f44" => :mojave
    sha256 "236779ca51f0503bc80da88ef43433976361d779ac851a5f65220b6ca84e7f44" => :high_sierra
    sha256 "3bf65ab7d6aa0308ef1a3c9ad16258b1c60addafe39ea89f9f4aad8fbb67f694" => :x86_64_linux
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
