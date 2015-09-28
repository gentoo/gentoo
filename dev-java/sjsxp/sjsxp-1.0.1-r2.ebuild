# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Sun Java Streaming XML Parser (SJSXP) is an efficient implementation of the StAX API"
HOMEPAGE="http://sjsxp.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="bea.ri.jsr173"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

IUSE=""

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/zephyr"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_dojar "build/${PN}.jar"

	use doc && java-pkg_dojavadoc build/docs/javadocs/sjsxp
	use source && java-pkg_dosrc src
}
