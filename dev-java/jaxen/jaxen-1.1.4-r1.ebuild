# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java XPath Engine"
HOMEPAGE="http://jaxen.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P}-src.tar.gz"

LICENSE="JDOM"
SLOT="1.1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

COMMON_DEP="
	dev-java/dom4j:1
	dev-java/jdom:0
	dev-java/xom:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEP}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="dom4j-1,jdom,xom"
EANT_TEST_EXTRA_ARGS="-DJunit.present=true"

java_prepare() {
	cp -v "${FILESDIR}"/${P}_maven1-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use examples && java-pkg_doexamples src/java/samples
	use source && java-pkg_dosrc src/java/main/*
}
