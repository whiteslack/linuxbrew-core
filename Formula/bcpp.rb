class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20200922.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/bcpp-20200922.tgz"
  sha256 "ec29f91b46d217933abb13f077b4de05bc5cf21b26550623ab196f360cebf10e"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b80a4d382855b882ec893247f9398aac9a6fd8bca0d8068062dc40895451942d" => :big_sur
    sha256 "a207df3cd0671539dabdc7b4b966acc9c640244a6449302c7bde96d8c61bf626" => :arm64_big_sur
    sha256 "e7c25aa0608c77248f3414b49ebfa7808673b4afea1925e57323c9b1384d8c03" => :catalina
    sha256 "75cfd0b4bf87b30217e8d36c29d083fd961425583e322b5fdfdf16f189009048" => :mojave
    sha256 "7bd443a2afe3a8bccdc39c0744de2e7b3f9c6d45ff11030c9757e434d4767b85" => :high_sierra
    sha256 "7a3c18fc561f6d09aa21cbef655544d335ed9a7aba5cd5882fb02c989c9bece2" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
