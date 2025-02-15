class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-12-18T10-53-53Z",
      revision: "d0e1456be34f39548148af45c2e64a61b3448a59"
  version "20201218105353"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([^"' >]+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "218b71bea4be4c2253b65c3d703771d6ed83170457101b597a623f8c3457c148" => :big_sur
    sha256 "a845d3658f70670bea009bd80da55cb2d7329f504f4d8e6390daeaad79b9c24f" => :catalina
    sha256 "5ac98c7afd304272465c645ace6a1796765b0c45990c7fc451b0cb77c744b728" => :mojave
    sha256 "f72fa2f573dad00ff811deb33c32c276de460a45c0d6135f89b6d5ab9858beb0" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
