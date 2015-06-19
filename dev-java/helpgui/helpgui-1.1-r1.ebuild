# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/helpgui/helpgui-1.1-r1.ebuild,v 1.5 2014/08/10 20:14:23 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="HelpGUI is a simple library which develop a help viewer component"
HOMEPAGE="http://helpgui.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	jar xf ${DISTDIR}/${A} || die
}

src_compile() {
	eant helpgui_jar $(use_doc javadocs)
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar

	dodoc README || die
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/*
}
