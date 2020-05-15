class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.125.0.tar.gz"
  sha256 "d4f0697a4cde590b7efeb78507dd3f3601dcdf62b54270efe2ce47fc5e0891a2"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a5ecaed1644399f546c242907e180a5c22ab237a057b23d34e38703e547e48e" => :catalina
    sha256 "da2e7589320d29e7600cf564307aa830ff46ed68c9d7ca2db2aa92829f57ff11" => :mojave
    sha256 "a7d94097547d9ce6058574aed8aac9a7c8bc18c9ccdaab4e59af803560683693" => :high_sierra
    sha256 "4c09dd625174434dbabbb16377b529a637cf9bc27b443ab51246b585e2c610c1" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  unless OS.mac?
    depends_on "rsync" => :build
    depends_on "elfutils"
  end

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
