# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="looks"
MY_PV=${PV//./_}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="JGoodies Looks Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="2.6"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/jgoodies-common:1.8"

RDEPEND="
	${CDEPEND}
	virtual/jre:1.8"

DEPEND="
	${CDEPEND}
	virtual/jdk:1.8"

BDEPEND="
	app-arch/unzip"


S="${WORKDIR}"/${P}

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="jgoodies-common-1.8"

src_prepare() {
	default
	mkdir src || die
	unzip ${P}-sources.jar -d src || die
	rm "${S}"/pom.xml "${S}"/*.jar || die
}
