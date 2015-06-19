# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-common/jgoodies-common-1.8.0.ebuild,v 1.1 2014/07/11 17:36:23 ercpe Exp $

EAPI="5"

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
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"/${P}

JAVA_SRC_DIR="src"

java_prepare() {
	mkdir src || die
	unzip ${P}-sources.jar -d src || die
	rm "${S}"/pom.xml "${S}"/*.jar || die
}
