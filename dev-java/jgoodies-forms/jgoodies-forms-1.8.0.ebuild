# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="forms"
MY_PV=${PV//./_}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="JGoodies Forms Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="1.8"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/jgoodies-common:${SLOT}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPEND}"

S="${WORKDIR}"/${P}

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="jgoodies-common-${SLOT}"

java_prepare() {
	mkdir src || die
	unzip ${P}-sources.jar -d src || die
	rm "${S}"/pom.xml "${S}"/*.jar || die
}
