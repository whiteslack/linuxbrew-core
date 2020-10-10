class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.0.tar.gz"
  sha256 "6be8cba2a0817cc1f50bfdbb7c4165bdef76e5207cd63ed14f478675d70295b6"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "35710972ebefbc5d57e250e0a712db29e206f75a13ff9c74e6f8ddc2e37f4ff0" => :catalina
    sha256 "b2e60f4e6138473288e9ffdec4b7cdedcfc7dfccc4a9474aec0dd8acffb49801" => :mojave
    sha256 "9d041cdb4a8e3375e9a98ee22a125d842df5ad58073c3d5912033d49779dfcf9" => :high_sierra
    sha256 "38d99a6e1389622acfd193cfd94dc1ffb6da6b6f5ef1eec2b92d052bfe9b4e8c" => :x86_64_linux
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  # Don't install service files
  on_linux do
    patch :DATA
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 54b3b291..72fd1088 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -316,27 +316,6 @@ if(FLB_BINARY)
     ENABLE_EXPORTS ON)
   install(TARGETS fluent-bit-bin RUNTIME DESTINATION ${FLB_INSTALL_BINDIR})

-  # Detect init system, install upstart, systemd or init.d script
-  if(IS_DIRECTORY /lib/systemd/system)
-    set(FLB_SYSTEMD_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.service")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/systemd.in"
-      ${FLB_SYSTEMD_SCRIPT}
-      )
-    install(FILES ${FLB_SYSTEMD_SCRIPT} DESTINATION /lib/systemd/system)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR})
-  elseif(IS_DIRECTORY /usr/share/upstart)
-    set(FLB_UPSTART_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.conf")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/upstart.in"
-      ${FLB_UPSTART_SCRIPT}
-      )
-    install(FILES ${FLB_UPSTART_SCRIPT} DESTINATION /etc/init)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR})
-  else()
-    # FIXME: should we support Sysv init script ?
-  endif()
-
   install(FILES
     "${PROJECT_SOURCE_DIR}/conf/fluent-bit.conf"
     DESTINATION ${FLB_INSTALL_CONFDIR}
