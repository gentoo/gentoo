# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gcalc/gcalc-3.1_rc1.ebuild,v 1.2 2012/05/21 19:54:33 ssuominen Exp $

EAPI="4"

inherit eutils java-pkg-2

MY_P="GCalc-${PV/_/-}"
DESCRIPTION="Java Mathematical Graphing System"
HOMEPAGE="http://gcalc.net/"
SRC_URI="http://gcalc.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""
SLOT="0"

RDEPEND=">=virtual/jre-1.4
	!!sci-mathematics/gcalc"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die
}

src_compile() {
	cd src || die
	ejavac $(find . -name '*.java')

	jar cf ${PN}.jar resources pluginlist.xml $(find . -name '*.class') || die
}

src_install() {
	java-pkg_dojar src/${PN}.jar
	java-pkg_dolauncher gcalc --main net.gcalc.calc.GCalc

	newicon src/resources/gicon.png ${PN}.png || die
	make_desktop_entry ${PN} "GCalc Java Mathematical Graphing System"
}
