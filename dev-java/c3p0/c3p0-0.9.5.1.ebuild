# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source examples test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Library for augmenting traditional (DriverManager-based) JDBC drivers with JNDI-bindable DataSources"
HOMEPAGE="http://c3p0.sourceforge.net/"

MY_P="${P}.src"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

CDEPEND="dev-java/log4j:0
	dev-java/mchange-commons:0"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	test? ( dev-java/junit:4 )
	"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="yes"

java_prepare() {
	find . -type f -name \*.jar -exec rm -v {} \; || die
	find . -type f -name \*.class -exec rm -v {} \; || die
	java-pkg_jar-from --into lib/ mchange-commons
	java-pkg_jar-from --into lib/ log4j

}

EANT_TEST_TARGET="junit-tests"
EANT_TEST_GENTOO_CLASSPATH="junit-4"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar build/${P}.jar
	dodoc README-SRC
	use doc && java-pkg_dojavadoc build/apidocs
	use source && java-pkg_dosrc src/java/com/mchange/v2
	use examples && java-pkg_doexamples src/java/com/mchange/v2/c3p0/example
}
