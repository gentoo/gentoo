# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="JSAP"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Java Simple Arguments Parser (JSAP)"
HOMEPAGE="https://sourceforge.net/projects/jsap"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

CDEPEND="
	dev-java/xstream:0
	dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="
	xstream
	ant-core
"

java_prepare() {
	java-pkg_clean
	find . -type f -name "Test*.java" -delete || die
}
