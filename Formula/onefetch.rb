class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.7.1.tar.gz"
  sha256 "ac2129ecc0ac1bf5ee9bf8a6511f3cfe9b53c873860745346c060ecc8f902848"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a128d6c69bbdf45527b7831b8f2bbd3da01aac885568100a42eac0ece1876fd" => :big_sur
    sha256 "89abea778eedc4f1eaf6fd6e470dd33dfb5c783065086e26055df047da187acd" => :catalina
    sha256 "984119bd82140f66accea4d58794080ed9bb0bf56704da2c8187e45e288cd785" => :mojave
    sha256 "62fab402b370f85fe536c49739b32b9d4c19d7edeaa6fe7f9417485492f63892" => :high_sierra
    sha256 "1f3f14c0781c9a5b5f6a26d714b43c44645009e7cb7a73b4c0d8883a542bd330" => :x86_64_linux
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp
    if ENV["CI"]
      system "git config --global user.email you@example.com"
      system "git config --global user.name Name"
    end
    system "git init && echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match /Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp
  end
end
