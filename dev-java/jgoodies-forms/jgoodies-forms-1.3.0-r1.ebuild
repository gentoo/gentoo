# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-forms/jgoodies-forms-1.3.0-r1.ebuild,v 1.1 2014/09/07 15:59:54 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_PN="forms"
MY_PV=${PV//./_}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="JGoodies Forms Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-macos"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}-${PV}"

EANT_FILTER_COMPILTER="jikes"

java_prepare() {
	find -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar build/${MY_PN}.jar

	dodoc RELEASE-NOTES.txt README.html || die

	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/{core,extras}/com
	use examples && java-pkg_doexamples src/tutorial
}
