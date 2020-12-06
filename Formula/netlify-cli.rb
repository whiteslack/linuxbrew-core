require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.2.tgz"
  sha256 "a79b5c6522b5316205ea76b344e2a7b7682f0d73621aa20ac8dc981c5cf3a6d5"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9c83871b122a9314f8e6c582abdfbc91f0df06fd4d3eb44e41a59803efd8f79a" => :big_sur
    sha256 "5305c960670d01b65c9542c1b1cc84a0e5fbf8af42bb592eba60af25527257bb" => :catalina
    sha256 "4808085174ba9071a05f5c1883ac257f9fb060c6c37cda52ba9f7d899e4cfecb" => :mojave
    sha256 "e758c2665bfb25253cae5f04ed5ce51689d21afb8b8bb214691a9a1014768abb" => :x86_64_linux
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
