# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 java-ant-2

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="http://www.freecol.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Rightly or wrongly, jogg and jorbis are bundled within Cortado but we
# don't have packages for them anyway.

CP_DEPEND="
	dev-java/commons-cli:1
	dev-java/cortado:0
	dev-java/miglayout:0
"

DEPEND=">=virtual/jdk-1.8
	app-arch/unzip
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8
	${CP_DEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/commons-cli-1.3.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

JAVA_ANT_REWRITE_CLASSPATH=true
EANT_BUILD_TARGET=package

src_prepare() {
	default
	rm -v jars/* || die
	java-pkg-2_src_prepare
}

src_install() {
	local datadir=/usr/share/${PN}

	java-pkg_dojar FreeCol.jar
	java-pkg_dolauncher ${PN} \
		--pwd ${datadir} \
		--main net.sf.freecol.FreeCol \
		--java_args -Xmx512M

	insinto ${datadir}
	doins -r data schema

	doicon data/${PN}.png
	make_desktop_entry ${PN} FreeCol

	dodoc README
}
