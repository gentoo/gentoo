# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_PN="forms"
MY_PV=${PV//./_}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="JGoodies library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MY_PN}-${PV}"

java_prepare() {
	java-pkg_clean
}

src_install() {
	java-pkg_dojar "build/${MY_PN}.jar"

	dodoc RELEASE-NOTES.txt README.html

	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/{core,extras}/com
	use examples && java-pkg_doexamples src/tutorial
}
