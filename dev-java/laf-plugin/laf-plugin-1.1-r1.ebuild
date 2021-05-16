# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Look'n'feel Java library"
HOMEPAGE="http://laf-plugin.dev.java.net"
SRC_URI="https://repo1.maven.org/maven2/net/java/dev/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/nanoxml:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

JAVA_GENTOO_CLASSPATH="nanoxml"

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
}
