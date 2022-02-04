# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 java-pkg-simple

MY_P="GCalc-${PV/_/-}"
DESCRIPTION="Java Mathematical Graphing System"
HOMEPAGE="http://gcalc.net/"
SRC_URI="http://gcalc.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

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
