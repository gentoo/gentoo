# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="jTDS - SQL Server and Sybase JDBC driver"
HOMEPAGE="http://jtds.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="1.3"
KEYWORDS="amd64"
RESTRICT="test" # Needs a running server

CDEPEND="dev-java/jcifs:1.1"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="src/main"
JAVA_ENCODING="ISO-8859-1"
JAVA_GENTOO_CLASSPATH="jcifs-1.1"

src_prepare() {
	default
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
