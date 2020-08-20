class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.1.tar.gz"
  sha256 "a6b6f7ac360d4aabd54e299cc1d8fa7b234cd81b9401693da21221c62569a23e"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d43c3811eef40b2ed82f7629a3cb8acab313f8459778e506de39d95b3cd0e5e3" => :catalina
    sha256 "b8a22ed5d7a0138d04e29d616e11c55d85733b7062911a8f0d9e1c4405cc4f61" => :mojave
    sha256 "8070023444b46cc29d7e52b71cdda279c4734d96d29c7785302ae0ffe27b1245" => :high_sierra
    sha256 "5f39f3d8ed3b572582989baab029d8f481d56200290745ea69f12278bf91f683" => :x86_64_linux
  end

  on_linux do
    depends_on "python@3.8" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin" unless OS.mac?

    system "python", "configure.py", "--bootstrap"

    # Quickly test the build
    system "./configure.py"
    system "./ninja", "ninja_test"
    system "./ninja_test", "--gtest_filter=-SubprocessTest.SetWithLots"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
  end
end
