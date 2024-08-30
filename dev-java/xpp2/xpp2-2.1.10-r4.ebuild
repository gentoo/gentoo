# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="pull-parser:pull-parser:2"

inherit java-pkg-2 java-pkg-simple

MY_PN="PullParser"
MY_P="${MY_PN}${PV}"

DESCRIPTION="A streaming pull XML parser used to quickly process input elements"
HOMEPAGE="https://web.archive.org/web/20130904163229/http://www.extreme.indiana.edu/xgws/xsoap/xpp/xpp2/"
SRC_URI="https://web.archive.org/web/20130904173708/http://www.extreme.indiana.edu/xgws/xsoap/xpp/download/PullParser2/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-1.1 IBM"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Some failures, partly because we haven't patched Xerces but probably
# also because this software is ancient. :(
RESTRICT="test"

CP_DEPEND="dev-java/xerces:2"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/${P}-fix-java5+.patch" )

JAVADOC_ARGS="-source 8"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean
	mkdir res || die
	cp -r src/java/impl/factory/META-INF res || die
	touch "res/PullParser${PV}_VERSION" || die

	mv src/{java/,}tests || die
	mv src/{java/,}samples || die
}

src_compile() {
	java-pkg-simple_src_compile
	rm xpp2.jar || die
	JAVA_JAR_FILENAME="PullParser.jar"

	cp -r target/classes parser || die
	rm -r parser/org/gjt/xpp/x2impl || die
	rm parser/org/gjt/xpp/impl/PullParserFactorySmallImpl.class || die
	jar cvf PullParser.jar -C parser . || die

	cp -r target/classes standard || die
	rm -r standard/{javax,org/xml} || die
	rm -r standard/org/gjt/xpp/{jaxp11,sax2,x2impl} || die
	rm standard/org/gjt/xpp/impl/PullParserFactorySmallImpl.class || die
	jar cvf PullParser-standard.jar -C standard . || die

	cp -r target/classes intf || die
	rm -r intf/{javax,org/xml,org/gjt/xpp/{impl,jaxp11,sax2,x2impl}} || die
	rm -r intf/META-INF || die
	jar cvf PullParser-intf.jar -C intf . || die

	cp -r target/classes x2 || die
	rm -r x2/org/gjt/xpp/impl/{pullparser,tokenizer} || die
	rm x2/org/gjt/xpp/impl/PullParserFactory* || die
	jar cvf PullParser-x2.jar -C x2 . || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar PullParser-{standard,intf,x2}.jar
}
