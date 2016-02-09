class Openmodelica < Formula
  desc "OpenModelica is an open-source Modelica-based modeling and simulation environment intended for industrial and academic usage."
  homepage "https://openmodelica.org/"
  url "https://github.com/RexFuzzle/OpenModelica/releases/download/v1.9.3/OpenModelica_v1.9.3_Complete.tar.gz"
  version "v1.9.3"
  sha256 "1cd3e5311a507b6dba676d5e91ed210147788d886bcd1405a97598516eaa38cd"

  head "https://github.com/OpenModelica/OpenModelica.git"
                                         # ,:revision => "4ab25f58d4b2a779b1db9e7feec9cbdbf418cf0c"
                                         #,:revision => "c3dd385ae1d2e287aa3acce84a97917e427e32ad"
                                         # or :branch => "develop"
                                         # or :tag => "1_0_release",
                                         #    :branch => "v1.9.3"
  devel do
    url "https://github.com/RexFuzzle/OpenModelica/releases/download/v1.9.4-dev-OSX/OpenModelica_v1.9.4_Devel.tar.gz"
    sha256 "7174cd72776ef691129c0dacebc508b317ff51a6c22ce4d64283305106857240"
  end

bottle do
  root_url "https://github.com/RexFuzzle/OpenModelica/releases/download/v1.9.3"
  sha256 "1637ed13b11ebb25c6db2a8aac097667f798ae06cd2a54148cf5b88e7314736f" => :el_capitan
end

	depends_on "qt4"
  depends_on "autoconf"
  depends_on "automake"
  depends_on "boost"
  depends_on "cmake"
  depends_on "expat"
  depends_on "gettext"
  depends_on "git"
  depends_on "gnu-sed"
  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "lapack"
  depends_on "liblas"
  depends_on "libtool"
  depends_on "lp_solve"
  depends_on "ncurses"
  depends_on "omniorb"
  depends_on "openblas"
  depends_on "readline"
  depends_on "sundials"
  depends_on "xz"
	conflicts_with "open-mpi", :because => "Causes issues in compiling. Can be reinstalled afterwards again"

  def install
    ENV['LDFLAGS']='-L/usr/local/opt/openblas/lib'
    ENV['CPPFLAGS']='-I/usr/local/opt/openblas/include'
    system "svn ls https://openmodelica.org/svn/OpenModelica --non-interactive --trust-server-cert"
    system "autoconf"
    system "./configure", "--disable-debug",
                          "--with-lapack=-lopenblas",
                          "--disable-modelica3d",
                          "--with-omniORB",
                          "--prefix=#{prefix}"

    system "make -j7 omc"
    system "make -j7 omlibrary-all"
    # system "(cd testsuite/partest && ./runtests.pl)"
    prefix.install Dir["build/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test OpenModelica`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/omc --version"
  end
end
