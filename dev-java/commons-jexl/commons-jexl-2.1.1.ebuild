# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Expression language engine, can be embedded in applications and frameworks"
HOMEPAGE="http://commons.apache.org/jexl/"
SRC_URI="mirror://apache/commons/jexl/source/${P}-src.tar.gz"

CDEPEND="dev-java/commons-logging:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	>=dev-java/javacc-5
	test? ( dev-java/ant-junit:0 )
	${CDEPEND}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${P}-src"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-logging"

# Dubious tests.
JAVA_RM_FILES=(
	src/test/java/org/apache/commons/jexl2/ArithmeticTest.java
)

java_prepare() {
	cp "${FILESDIR}"/${PV}-build.xml build.xml || die

	# these two calls is what the "jjtree-javacc" goal in the pom.xml does
	jjtree -OUTPUT_DIRECTORY="${S}/src/main/java/org/apache/commons/jexl2/parser/" \
		src/main/java/org/apache/commons/jexl2/parser/Parser.jjt \
		|| die "Code generation via jjtree failed"
	javacc -OUTPUT_DIRECTORY="${S}/src/main/java/org/apache/commons/jexl2/parser/" \
		src/main/java/org/apache/commons/jexl2/parser/Parser.jj \
		|| die "Parser.java code generation via javacc failed"
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	dodoc RELEASE-NOTES.txt NOTICE.txt
	use doc && java-pkg_dojavadoc "${S}"/target/site/apidocs
	use source && java-pkg_dosrc "${S}"/src/main/java/*
}
