# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

# NB: this project is dead and we should look into removing it from the tree.
# Take a look at the homepage.
DESCRIPTION="Easy-to-use Java logging toolkit"
HOMEPAGE="http://avalon.apache.org/"
SRC_URI="mirror://apache/excalibur/excalibur-logkit/source/${P}-src.tar.gz"

KEYWORDS="amd64 ~arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
LICENSE="Apache-2.0"
SLOT="2.0"
IUSE=""

CDEPEND="
	dev-java/log4j:0
	java-virtuals/jms:0
	dev-java/oracle-javamail:0
	java-virtuals/servlet-api:3.0"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
	)"

java_prepare() {
	# Doesn't like 1.6 / 1.7 changes to JDBC
	epatch "${FILESDIR}/${P}-java7.patch"

	java-ant_ignore-system-classes

	java-ant_xml-rewrite \
		-f build.xml \
		-c -e available \
		-a classpathref \
		-v 'build.classpath' || die

	java-pkg_filter-compiler jikes
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_ENCODING="UTF-8"

EANT_GENTOO_CLASSPATH="oracle-javamail,jms,log4j,servlet-api-3.0"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
