class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.28.1.tar.gz"
  sha256 "dcba3a9e4e8f4956af46b797dae0a701f6043e879746b33cc744ea2a5542ae76"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd272e2bbe76e54caced1523e90ec249296d36b83dafdd27b74f3cfe2ab2ac0b" => :big_sur
    sha256 "f8754b57754c8f8055c525f1eb7d237f491ec9441a5498bc970c9b18c759f796" => :arm64_big_sur
    sha256 "b4e2f2425b38eb74ed2cff1b2ab9bfb99210f5a527bc82f3c2abafbd4a21d94e" => :catalina
    sha256 "168945571441dec3ee1eece262ab3f8363e831a4ff585748355b31a59de24feb" => :mojave
    sha256 "6597c18df4c105cda4053a33da3536c16bb5560d46caeb28b0040c4e50fa3d75" => :high_sierra
    sha256 "c4859dc2e6593ea29fa6ef1d30ad93a2ae9b72247d6a8d56366b5ac79ffdfbcc" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
