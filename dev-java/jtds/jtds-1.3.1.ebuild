# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="jTDS - SQL Server and Sybase JDBC driver"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://jtds.sourceforge.net"
LICENSE="LGPL-2.1"
SLOT="1.3"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # Needs a running server

CDEPEND="dev-java/jcifs:1.1"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	app-arch/unzip"

JAVA_SRC_DIR="src/main"
JAVA_ENCODING="ISO-8859-1"
JAVA_GENTOO_CLASSPATH="jcifs-1.1"

java_prepare() {
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar ${JAVA_SRC_DIR}
}

src_install() {
	java-pkg-simple_src_install
	dodoc CHANGELOG README*
}
