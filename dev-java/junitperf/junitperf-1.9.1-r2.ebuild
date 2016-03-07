# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc test source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="http://www.clarkware.com/software/${P}.zip"
HOMEPAGE="http://www.clarkware.com/software/JUnitPerf.html"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

IUSE=""

CDEPEND="dev-java/junit:4"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? ( dev-java/ant-junit:0 )
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

java_prepare() {
	java-pkg_clean
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="junit-4"
EANT_DOC_TARGET="doc"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}"
EANT_TEST_TARGET="test"

src_test() {
	ANT_TASKS="ant-junit" java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar "lib/${PN}.jar"
	dodoc README
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/app/*
}
