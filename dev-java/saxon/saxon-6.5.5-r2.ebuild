# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple versionator

MY_P="${PN}$(replace_all_version_separators -)"

DESCRIPTION="Set of tools for processing XML documents"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://saxon.sourceforge.net/"

LICENSE="MPL-1.1"
SLOT="6.5"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/jdom:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="jdom"
JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src"

src_unpack() {
	unpack ${A}
	unzip -qq source.zip -d src || die "failed to unpack"
}

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	default
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples samples
}
