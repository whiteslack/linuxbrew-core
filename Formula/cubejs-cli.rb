require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.6.tgz"
  sha256 "fca63b313d8d040ec789e4ba7d06823b40749e52970286ff0bc21ab9d4d876f5"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c847e486c625defd338bdb6761784eb9b2020eb4997d828b150e0cbfcca5cd92" => :big_sur
    sha256 "c0f24b1c8a07741cd47104d831ea33c55e573b67c31668e05bbbc2bfa83616f1" => :arm64_big_sur
    sha256 "fb9cc1e0b3fd78aa7f0ba8a3e34c5efb907c5f258191ef9559e017fc7e17eeec" => :catalina
    sha256 "b08846743cc12d685f73f30822736c94c6344a530d1349ed774657a41c7fadb8" => :mojave
    sha256 "6d8ecde6f77732920e3c06a8f6068273bc16ebc5f6aa3137f9178fc351a558e6" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
