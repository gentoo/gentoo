# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

MY_PN="AppFramework"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Set of Java classes to build desktop applications easily"
HOMEPAGE="https://java.net/projects/appframework"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${MY_P}-src.zip -> ${P}.zip"

LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/jnlp-api:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="jnlp-api"

JAVA_SRC_DIR="src"

PATCHES=( "${FILESDIR}/${P}-fix-imports.patch" )

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	java-pkg_clean
	mv src/examples "${S}" || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
}
