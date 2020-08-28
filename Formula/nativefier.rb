require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-9.2.0.tgz"
  sha256 "2d0964cbebde6a4a1fe1d8bb467677700c05f751b296ddd1181d1c93769f35d4"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9af138aa796efacc377de35b1020091e48a7c3c1ffca3ca32b7ed603dba00a93" => :catalina
    sha256 "95e4333fe5aa40f5fa0bfc004b902454547e4ddadceb16903fb310fbba28e537" => :mojave
    sha256 "3de61007eb5af8c64c52362fa540d098c169c8433fc689edfa0a7075e5b03756" => :high_sierra
    sha256 "256ab049bf97eb55472a62f2088735c035c79bb7b2f4bb03a646a2fc776e0b7f" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
