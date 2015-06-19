# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-binding/jgoodies-binding-1.1.2-r1.ebuild,v 1.1 2014/09/07 15:53:57 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_V=${PV//./_}
DESCRIPTION="A Java library to bind object properties with UI components"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/binding-${MY_V}.zip"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4.2
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.4.2
		examples? ( >=dev-java/jgoodies-looks-1.0.5 )"

S=${WORKDIR}/binding-${PV}

RESTRICT="test"

EANT_FILTER_COMPILER="jikes"

java_prepare() {
	find -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar build/binding.jar

	dodoc RELEASE-NOTES.txt || die
	dohtml README.html || die
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/core/com
	use examples && java-pkg_doexamples src/tutorial
}
