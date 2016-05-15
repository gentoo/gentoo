# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Sun Java Streaming XML Parser"
HOMEPAGE="http://sjsxp.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="bea.ri.jsr173"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

CDEPEND="dev-java/xpp3:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/zephyr"

JAVA_GENTOO_CLASSPATH="xpp3"
JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
	rm -rv tests || die
}
