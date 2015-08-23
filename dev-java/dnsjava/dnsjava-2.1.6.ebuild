# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An implementation of DNS in Java"
HOMEPAGE="http://www.dnsjava.org/"
SRC_URI="http://www.dnsjava.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
		test? (
			dev-java/junit:0
			dev-java/ant-junit:0
		)"

EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="docs"
EANT_TEST_TARGET="run_tests"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_TEST_GENTOO_CLASSPATH="junit"
EANT_GENTOO_CLASSPATH_EXTRA="${P}.jar"

java_prepare() {
	find -name "*.jar" -delete || die
	epatch "${FILESDIR}"/${PV}-*.patch
}

src_install() {
	java-pkg_newjar "${P}.jar"

	dodoc README USAGE || die
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc org/
}

src_test() {
	EANT_ANT_TASKS="ant-junit" java-pkg-2_src_test
}
