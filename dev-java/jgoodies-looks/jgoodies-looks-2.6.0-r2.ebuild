# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="looks"
MY_PV=${PV//./_}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="JGoodies Looks Library"
HOMEPAGE="https://www.jgoodies.com"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"
S="${WORKDIR}"/${P}

LICENSE="BSD"
SLOT="2.6"
KEYWORDS="amd64"

CP_DEPEND="dev-java/jgoodies-common:1.8"

RDEPEND="
	${CP_DEPEND}
	virtual/jre:1.8
"

DEPEND="
	${CP_DEPEND}
	virtual/jdk:1.8
"

BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir src || die
	unzip ${P}-sources.jar -d src || die
	rm "${S}"/*.jar || die
}
