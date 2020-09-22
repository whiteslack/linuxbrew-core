class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.20.0.tar.gz"
  sha256 "ccecbfd49d03ca45f347fe55b789b8732003ceab49a14af110390e723f2fd274"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9c459637ae22d47af363252600d3562e97bc3acb54da70d02b88a2a8a52856f" => :catalina
    sha256 "897a52fd71d3964a2ebf30378448a6be68766613d3925e52e006ec34422c39ad" => :mojave
    sha256 "742b84228cec2edc94554fb727ed8e6571c16fad711e6f0d42110be3da734c25" => :high_sierra
    sha256 "512a62c4f9236def54e4d5355d5a1d647cfd55ac893b3b53f17eecf7506f9b83" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  unless OS.mac?
    depends_on "linuxbrew/xorg/libxcb"
    depends_on "linuxbrew/xorg/libx11"
  end

  def install
    system "cargo", "install", "--features", "stable", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
