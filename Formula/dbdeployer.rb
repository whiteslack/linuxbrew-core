class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.55.0.tar.gz"
  sha256 "898f8d7d478cca57728b596473a095f082e83b2027d488779846d4e189f4a0aa"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb64fa2235307cde79cbdb62eb0b6bf0ed97da264f791fdb7b8a844194c9d1af" => :catalina
    sha256 "6cea16d3066446b68ba57f5cc8c5505b7dfc637b462a4a151bbab5077dd8f1f3" => :mojave
    sha256 "fb35d80d90b883f8c100bca714d37b7579e296ba5f27d00473cabf5c7c2ab84e" => :high_sierra
    sha256 "915707dbdf3e1584a6a84098afdaa96da635a2d8cb028b4cf122389980414813" => :x86_64_linux
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
