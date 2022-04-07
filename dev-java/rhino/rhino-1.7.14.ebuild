# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.mozilla:rhino:1.7.14"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An open-source implementation of JavaScript written in Java"
HOMEPAGE="https://github.com/mozilla/rhino"
SRC_URI="https://github.com/mozilla/rhino/archive/Rhino${PV//./_}_Release.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-1.1 GPL-2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
SLOT="1.6"

# There are too many test failures:
# FAILURES!!!
# Tests run: 10504,  Failures: 613
# With openjdk-11 tests even fail to compile:
# ./testsrc/tests/src/com/netscape/javascript/qa/liveconnect/LiveConnectTest.java:104: error: cannot find symbol
#         global  = JSObject.getWindow( this );
#                           ^
#   symbol:   method getWindow(LiveConnectTest)
#   location: class JSObject
RESTRICT="test"

DEPEND=">=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
		dev-java/emma:0
		dev-java/jakarta-xml-soap-api:1
		dev-java/jmh-core:0
		dev-java/hamcrest-core:1.3
		dev-java/snakeyaml:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

DOCS=( {CODE_OF_CONDUCT,README,RELEASE-NOTES,RELEASE-STEPS}.md {NOTICE-tools,NOTICE}.txt )

S="${WORKDIR}/rhino-Rhino${PV//./_}_Release"

JAVA_SRC_DIR=( "src" "toolsrc" "xmlimplsrc" )
JAVA_RESOURCE_DIRS="res"
JAVA_MAIN_CLASS="org.mozilla.javascript.tools.shell.Main"

JAVA_TEST_GENTOO_CLASSPATH="ant-junit,emma,hamcrest-core-1.3,jakarta-xml-soap-api-1,jmh-core,junit-4,snakeyaml"
JAVA_TEST_SRC_DIRS="testsrc"
JAVA_TEST_RESOURCE_DIRS="testres"

# https://github.com/mozilla/rhino/blob/Rhino1_7_14_Release/build.gradle#L81-L87
JAVA_TEST_EXTRA_ARGS=(
	-Djava.awt.headless=true
	-Dmozilla.js.tests=testsrc/tests
	-Dmozilla.js.tests.timeout=60000
	-Duser.language=en
	-Duser.country=US
	-Duser.timezone=America/Los_Angeles
	-Dfile.encoding=UTF-8
)

src_prepare() {
	default
	java-pkg_clean

	mkdir -p res/org/mozilla/javascript/tools/{resources,debugger} || die

	cp -r "src/org" "res" || die
	find "res" -type f -name '*.java' -exec rm -rf {} + || die

	cp {toolsrc,res}/org/mozilla/javascript/tools/resources/Messages.properties || die
	cp {toolsrc,res}/org/mozilla/javascript/tools/debugger/test.js || die

	mv {src,testsrc}/org/mozilla/javascript/engine || die
	cp -r "testsrc" "testres" || die
	find "testres" -type f -name '*.java' -exec rm -rf {} + || die

	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/LiveConnectDrv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/LiveConnectEnv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/LiveNavDrv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/LiveNavEnv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/MacRefEnv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/NavDrv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/NavEnv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/ObservedTask.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/RefDrv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/RefEnv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/RhinoDrv.java || die
	rm testsrc/tests/src/com/netscape/javascript/qa/drivers/RhinoEnv.java || die
}

src_test() {
	# https://github.com/mozilla/rhino/blob/Rhino1_7_14_Release/build.gradle#L71-L77
	rm -r testsrc/benchmarks || die

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -gt "1.8" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.desktop/javax.swing.table=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
