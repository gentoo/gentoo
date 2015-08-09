# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit base eutils java-pkg-2 java-ant-2 games

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="http://www.freecol.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="dev-java/jsr173
	dev-java/wstx:3.2
	dev-java/commons-cli:1
	dev-java/cortado
	dev-java/miglayout"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

java_prepare() {
	cd jars
	rm jsr173_1.0_api.jar
	rm wstx-lgpl-4.0pr1.jar
	rm commons-cli-1.1.jar
	rm miglayout-3.7.3.1-swing.jar
	rm cortado-0.6.0.jar
	rm jogg-0.0.7.jar
	rm jorbis-0.0.15.jar
}

src_prepare() {
	base_src_prepare
	java-pkg-2_src_prepare
}

src_configure() {
	java-ant-2_src_configure
}

src_compile() {
	EANT_BUILD_TARGET=package
	EANT_EXTRA_ARGS="
		-Dstax.jar=$(java-pkg_getjars jsr173)
		-Dwoodstox.jar=$(java-pkg_getjars wstx-3.2)
		-Dcli.jar=$(java-pkg_getjars commons-cli-1)
		-Dmiglayout.jar=$(java-pkg_getjars miglayout)
		-Dcortado.jar=$(java-pkg_getjars cortado)
	"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_jarinto "${GAMES_DATADIR}"/${PN}/jars
	java-pkg_dojar jars/vorbisspi1.0.3.jar
	java-pkg_dojar jars/tritonus_share.jar
	java-pkg_jarinto "${GAMES_DATADIR}"/${PN}
	java-pkg_dojar FreeCol.jar
	java-pkg_dolauncher ${PN} \
		-into "${GAMES_PREFIX}" \
		--pwd "${GAMES_DATADIR}"/${PN} \
		--jar FreeCol.jar \
		--java_args -Xmx512M
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data schema splash.jpg
	doicon ${PN}.xpm
	make_desktop_entry ${PN} FreeCol
	dodoc README
	prepgamesdirs
}

pkg_setup() {
	games_pkg_setup
	java-pkg-2_pkg_setup
}

pkg_preinst() {
	games_pkg_preinst
	java-pkg-2_pkg_preinst
}
