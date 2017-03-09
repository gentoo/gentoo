# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-pkg-2 java-pkg-simple

MY_P="GCalc-${PV/_/-}"
DESCRIPTION="Java Mathematical Graphing System"
HOMEPAGE="http://gcalc.net/"
SRC_URI="http://gcalc.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""
SLOT="0"

RDEPEND=">=virtual/jre-1.7
	!!sci-mathematics/gcalc"
DEPEND=">=virtual/jdk-1.7"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	java-pkg_clean
	default
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src ! -name "*.html"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher gcalc --main net.gcalc.calc.GCalc

	newicon src/resources/gicon.png ${PN}.png
	make_desktop_entry ${PN} "GCalc Java Mathematical Graphing System"
}
