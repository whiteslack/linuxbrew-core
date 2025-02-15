class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.150.1",
      revision: "8e45550e5034325d9a5f6ac2b3ad08e9786eebc3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6913b124f249663bfca39202bce6d1cdf509e2ccce80880c83edae9241c9dea2" => :big_sur
    sha256 "18f92f6ec388a1bed44514e99f89740636264f199752d87cb6922fd8e6c04a1a" => :arm64_big_sur
    sha256 "b95ea5c3c26d4b8472f1eb3ed70c9ae2011711525d2ec9603d840ce5b2879453" => :catalina
    sha256 "a94285ff3dcb2683d5b9301e9546c27816cea8efa581bd9718659297589c0701" => :mojave
    sha256 "b18d9e6f85deef7c2e897ccaa75bbb3eef6545de5e4e1a7af642645507d66e30" => :x86_64_linux
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
