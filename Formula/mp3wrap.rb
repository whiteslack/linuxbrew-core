class Mp3wrap < Formula
  desc "Wrap two or more mp3 files in a single large file"
  homepage "https://mp3wrap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz"
  sha256 "1b4644f6b7099dcab88b08521d59d6f730fa211b5faf1f88bd03bf61fedc04e7"

  livecheck do
    url :stable
    regex(%r{url=.*?/mp3wrap[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb2198208b5da896231a815235652c3342ed305a858950c9fb10bc7e296d1e34" => :big_sur
    sha256 "9ee84cc1015ba99900a71896d7055b3fcf305828dc6a8430da552b0fee18a01b" => :arm64_big_sur
    sha256 "fa93ce86b2a055521e166325b4219773f04c6886075bd77932dcb6dff436ddce" => :catalina
    sha256 "ef3c37644b60e3644b2763a999ab189ceffe59d0506617db2d23cb3f3b430056" => :mojave
    sha256 "3c85e837e2dbcfcbbccb0b074ebfa9283c13d2453b206c246bc4d77600328dfb" => :high_sierra
    sha256 "0471701ab4f6b59423503b7c250376ba597a9f28d9962f6f9b35a107d58411ab" => :sierra
    sha256 "c65886799c1397eec33f48ef73774ad6a509fec44a18dec4a50c8755736f040a" => :el_capitan
    sha256 "50e1b97fa8423acc0c3980c7171544cf248b049d31cb1c6d3ba1214c293bc2eb" => :mavericks
    sha256 "3adc636d92aaebfbd374697860bdd14df965f70586d845696bb5094afa1ebfd7" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    source = test_fixtures("test.mp3")
    system "#{bin}/mp3wrap", "#{testpath}/t.mp3", source, source
    assert_predicate testpath/"t_MP3WRAP.mp3", :exist?
  end
end
