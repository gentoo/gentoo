# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java-based STUN implementation"
HOMEPAGE="http://jstun.javawi.de/"
SRC_URI="http://${PN}.javawi.de/${P}.src.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="dev-java/slf4j-api:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit:0 )
	${COMMON_DEP}"

S="${WORKDIR}/STUN"

# Tests contain no main function; demos contain main function, but contact
# external domains as well as aren't really tests. TODO: A main function needs
# to be written in order to be able to test de.javawi.jstun.AllTests.
RESTRICT="test"

EANT_BUILD_XML="build/build.xml"

java_prepare() {
	rm -v *.jar || die
	rm -v build/*.jar || die

	java-pkg_jar-from slf4j-api
}

EANT_TEST_GENTOO_CLASSPATH="junit"
EANT_TEST_TARGET="jar-test"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_test() {
	local cp="$(java-pkg_getjars --build-only junit)"

	java-pkg-2_src_test

	java -cp target/${PN}-test-${PV}.jar:${cp} de.javawi.jstun.AllTests \
		|| die "Tests failed."
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/javadoc
	use source && java-pkg_dosrc src
}
