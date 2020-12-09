class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.57.0.tar.gz"
  sha256 "c8c84802cffcf3f8ac433c92fc13b75d966321bb8ac89efc4f1142618f896576"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc872b9096b1b93ff20408c90adf9c52f14460b2f25aaf55fb601fee7e31f36a" => :big_sur
    sha256 "2662fbc7ff443f1941dfc13f72f336100d2d866637fdf6d366dff854e17de4f4" => :catalina
    sha256 "8706acc54a4278288eb16cb84c111b40a4380b366a9deb118c81de5387d73dd6" => :mojave
    sha256 "b274b7b0c3c48730d8b228efa1c1cd23c6e301b79d9105df14f88829a5474877" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "./scripts/build.sh", OS.mac? ? "OSX" : "linux"
    bin.install "dbdeployer-#{version}.#{OS.mac? ? "osx" : "linux"}" => "dbdeployer"
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
