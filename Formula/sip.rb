class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.24/sip-4.19.24.tar.gz"
  sha256 "edcd3790bb01938191eef0f6117de0bf56d1136626c0ddb678f3a558d62e41e5"
  license ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "27b5d4e78eee2d5cba8154d292b334e111a1d1e7c718bde664c352a542e15426" => :catalina
    sha256 "59a0106736b84dd8f03c720ac425e5608e1bde788ba73ccc923397aa2dbdcef3" => :mojave
    sha256 "a0f6f7d9f231644e1ab81c3a40de9e4f8afcae06b1d54959613263e84adfa958" => :high_sierra
    sha256 "6caecc9ce56c128f9392edc79c44325c75436954c698f5dbea7f5fc98c028d6d" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_bin
    ENV.delete("SDKROOT") # Avoid picking up /Application/Xcode.app paths

    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s cached_download/".hg", ".hg"
      # build.py doesn't run with python3
      system "python", "build.py", "prepare"
    end

    version = Language::Python.major_minor_version "python3"
    system "python3", "configure.py",
                     *("--deployment-target=#{MacOS.version}" if OS.mac?),
                      "--destdir=#{lib}/python#{version}/site-packages",
                      "--bindir=#{bin}",
                      "--incdir=#{include}",
                      "--sipdir=#{HOMEBREW_PREFIX}/share/sip",
                      "--sip-module", "PyQt5.sip"
    system "make"
    system "make", "install"
  end

  def post_install
    (HOMEBREW_PREFIX/"share/sip").mkpath
  end

  test do
    (testpath/"test.h").write <<~EOS
      #pragma once
      class Test {
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "test.h"
      #include <iostream>
      Test::Test() {}
      void Test::test()
      {
        std::cout << "Hello World!" << std::endl;
      }
    EOS
    (testpath/"test.sip").write <<~EOS
      %Module test
      class Test {
      %TypeHeaderCode
      #include "test.h"
      %End
      public:
        Test();
        void test();
      };
    EOS
    if OS.mac?
      system ENV.cxx, "-shared", "-Wl,-install_name,#{testpath}/libtest.dylib",
                    "-o", "libtest.dylib", "test.cpp"
    else
      system ENV.cxx, "-fPIC", "-shared", "-Wl,-soname,#{testpath}/libtest.so",
                    "-o", "libtest.so", "test.cpp"
    end
    system bin/"sip", "-b", "test.build", "-c", ".", "test.sip"
  end
end
