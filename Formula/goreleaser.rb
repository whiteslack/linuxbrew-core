class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.144.1",
      revision: "229c8f54a51a8b25313a752016983c44e47e0214"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "431afd44896b1efb38acb1a6b3a4b9d41e850472451ef63294ece5fefd196e21" => :catalina
    sha256 "2a63b85b61e69b848aa1043da487c2f77b1037b8324769bad041c9899573a53e" => :mojave
    sha256 "932bda02b5ab2f84d227487db44b7766c0359d2bbf5b8d8237a7ea9132ffa3b3" => :high_sierra
    sha256 "0116b80f15ba320b16cb9e9d873779a9f8b6708aeacba37b2b3b77d0317c19c9" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
