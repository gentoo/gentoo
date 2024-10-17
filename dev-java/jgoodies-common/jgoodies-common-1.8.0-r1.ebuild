# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="common"
MY_PV=${PV//./_}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="JGoodies Common Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="1.8"
KEYWORDS="amd64 ~ppc64"
IUSE=""

RESTRICT="test"

RDEPEND=">=virtual/jre-1.8:*"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.8:*"

S="${WORKDIR}"/${P}

JAVA_SRC_DIR="src"

src_prepare() {
	default
	mkdir src || die
	unzip ${P}-sources.jar -d src || die
	rm "${S}"/pom.xml "${S}"/*.jar || die
}
