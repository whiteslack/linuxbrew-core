class Akka < Formula
  desc "Toolkit for building concurrent, distributed, and fault tolerant apps"
  homepage "http://akka.io/"
  url "https://downloads.typesafe.com/akka/akka_2.11-2.4.4.zip"
  sha256 "f449ac4a9f401d2c25618c7d49a2e63f9c1c0e608f44854c06a604eec5f72d66"

  bottle :unneeded

  depends_on :java

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    chmod 0755, "bin/akka"
    chmod 0755, "bin/akka-cluster"

    inreplace ["bin/akka", "bin/akka-cluster"] do |s|
      # Translate akka script
      s.gsub! /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}"
      # dos to unix (bug fix for version 2.3.11)
      s.gsub! /\r?/, ""
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/akka"
    bin.install_symlink libexec/"bin/akka-cluster"
  end

  test do
    (testpath/"src/main/java/sample/hello/HelloWorld.java").write <<-EOS.undent
      package sample.hello;

      import akka.actor.Props;
      import akka.actor.UntypedActor;
      import akka.actor.ActorRef;

      public class HelloWorld extends UntypedActor {

        @Override
        public void preStart() {
          // create the greeter actor
          final ActorRef greeter = getContext().actorOf(Props.create(Greeter.class), "greeter");
          // tell it to perform the greeting
          greeter.tell(Greeter.Msg.GREET, getSelf());
        }

        @Override
        public void onReceive(Object msg) {
          if (msg == Greeter.Msg.DONE) {
            // when the greeter is done, stop this actor and with it the application
            getContext().stop(getSelf());
          } else
            unhandled(msg);
        }
      }
    EOS
    (testpath/"src/main/java/sample/hello/Greeter.java").write <<-EOS.undent
      package sample.hello;

      import akka.actor.UntypedActor;

      public class Greeter extends UntypedActor {

        public static enum Msg {
          GREET, DONE;
        }

        @Override
        public void onReceive(Object msg) {
          if (msg == Msg.GREET) {
            System.out.println("Hello World!");
            getSender().tell(Msg.DONE, getSelf());
          } else
            unhandled(msg);
        }

      }
    EOS
    (testpath/"src/main/java/sample/hello/Main.java").write <<-EOS.undent
      package sample.hello;

      public class Main {

        public static void main(String[] args) {
          akka.Main.main(new String[] { HelloWorld.class.getName() });
        }
      }
    EOS
    system "javac", "-classpath", Dir[libexec/"lib/**/*.jar"].join(":"),
      testpath/"src/main/java/sample/hello/HelloWorld.java",
      testpath/"src/main/java/sample/hello/Greeter.java",
      testpath/"src/main/java/sample/hello/Main.java"
    system "java",
      "-classpath", (Dir[libexec/"lib/**/*.jar"] + [testpath/"src/main/java"]).join(":"),
      "akka.Main", "sample.hello.HelloWorld"
  end
end
