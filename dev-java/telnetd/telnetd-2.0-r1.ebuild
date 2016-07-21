# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A telnet daemon for use in Java applications"
HOMEPAGE="http://telnetd.sourceforge.net/"
SRC_URI="mirror://sourceforge/telnetd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/commons-logging:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="commons-logging"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" src -name "*.properties"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher "j${PN}" --main net.wimpi.telnetd.TelnetD
}
