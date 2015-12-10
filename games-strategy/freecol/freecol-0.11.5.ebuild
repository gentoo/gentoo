# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils java-pkg-2 java-ant-2 games

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="http://www.freecol.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="dev-java/jsr173
	dev-java/wstx:3.2
	dev-java/commons-cli:1
	dev-java/cortado
	dev-java/miglayout"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.7
	${COMMON_DEP}"

S=${WORKDIR}/${PN}

java_prepare() {
	# jorbis isn't in portage yet
	rm jars/{commons-cli-1.1,cortado-0.6.0,miglayout-core-4.2,miglayout-swing-4.2}.jar || die
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_prepare() {
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
	java-pkg_jarinto "${GAMES_DATADIR}"/${PN}
	java-pkg_dojar FreeCol.jar
	java-pkg_dolauncher ${PN} \
		-into "${GAMES_PREFIX}" \
		--pwd "${GAMES_DATADIR}"/${PN} \
		--jar FreeCol.jar \
		--java_args -Xmx512M
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data schema splash.jpg
	doicon data/${PN}.png
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
