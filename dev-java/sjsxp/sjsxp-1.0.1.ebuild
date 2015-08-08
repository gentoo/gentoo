# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Sun Java Streaming XML Parser (SJSXP) is an efficient implementation of the StAX API"
HOMEPAGE="http://sjsxp.dev.java.net/"
# CVS: cvs -d :pserver:guest@cvs.dev.java.net:/cvs checkout -r sjsxp-1_0_1 sjsxp/zephyr
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="bea.ri.jsr173"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

IUSE=""

COMMON_DEP="dev-java/jsr173"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

S="${WORKDIR}/zephyr"

src_unpack() {
	unpack ${A}

	cd "${S}/lib"
	java-pkg_jar-from jsr173 jsr173.jar jsr173_1.0_api.jar
}

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_dojar "build/${PN}.jar"

	use doc && java-pkg_dojavadoc build/docs/javadocs
	use source && java-pkg_dosrc src
}
