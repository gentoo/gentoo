# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 java-pkg-simple

MY_P="GCalc-${PV/_/-}"
DESCRIPTION="Java Mathematical Graphing System"
HOMEPAGE="https://gcalc.net/"
SRC_URI="https://gcalc.net/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="net.gcalc.calc.GCalc"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
	mkdir res || die
	mv {src,res}/resources || die
	cp {src,res}/pluginlist.xml || die
}

src_install() {
	java-pkg-simple_src_install
	newicon res/resources/gicon.png ${PN}.png
	make_desktop_entry ${PN} "GCalc Java Mathematical Graphing System"
}
