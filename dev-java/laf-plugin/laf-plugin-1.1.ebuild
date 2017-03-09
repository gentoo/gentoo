# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A generic plugin framework for look-and-feels"
HOMEPAGE="http://laf-plugin.dev.java.net/"
SRC_URI="https://repo1.maven.org/maven2/net/java/dev/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/nanoxml:0"

DEPEND="
	>=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND="
	>=virtual/jre-1.6
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="nanoxml"

java_prepare() {
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
}
