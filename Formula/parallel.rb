class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200722.tar.bz2"
  sha256 "4801d44f2f71eed26386a0623a6fb3cadd7fa7ec2b5a7bbc5b7b52e2a0450d6f"
  license "GPL-3.0"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fde839462cca26fdce64a9f0dc11e50d073234e4c2878838a7434b87c8683095" => :catalina
    sha256 "fde839462cca26fdce64a9f0dc11e50d073234e4c2878838a7434b87c8683095" => :mojave
    sha256 "fde839462cca26fdce64a9f0dc11e50d073234e4c2878838a7434b87c8683095" => :high_sierra
    sha256 "d90510b43a1bab4fa735721efc50884c5e6f69f3d06893a2021df5e2c9d76051" => :x86_64_linux
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
