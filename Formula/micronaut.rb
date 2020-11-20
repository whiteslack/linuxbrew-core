class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.2.0.tar.gz"
  sha256 "40680a055eb457a5d1e2f440a057aaa8f6d619c5e75424850c936f0ae9fb75b8"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/micronaut-projects/micronaut-starter/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a92f0f9587df3ab830ae1a1deb4f69428ccc90813d2c3ef2bc80274af286de5" => :big_sur
    sha256 "7c1c1cf2d047374ff0eaee5e0d6abcf35ca0c81e8e6f752d0e16d5d7f6d98f5b" => :catalina
    sha256 "6fc55e9e94083ed0c025070af3168c4908373175c9541520d91f17d831fa38eb" => :mojave
    sha256 "983ae087ee9959ee724c7bcd9e473bb6cb2d2d552141f2683332a9bd92539ba8" => :x86_64_linux
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
