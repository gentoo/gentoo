# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/telnetd/telnetd-2.0.ebuild,v 1.4 2007/11/25 14:33:48 ranger Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A telnet daemon for use in java applications"
HOMEPAGE="http://telnetd.sourceforge.net/"
SRC_URI="mirror://sourceforge/telnetd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEP="dev-java/commons-logging"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}

	cd  "${S}/lib/"
	rm -v *.jar || die
	java-pkg_jar-from commons-logging
}

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_dojar build/telnetd.jar
	dodoc README.txt || die

	use doc && java-pkg_dojavadoc build/site/api
	use source && java-pkg_dosrc src/net
}
