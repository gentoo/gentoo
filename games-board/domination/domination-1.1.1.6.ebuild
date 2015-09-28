# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils java-pkg-2 java-ant-2 games

DESCRIPTION="The well-known board game, written in java"
HOMEPAGE="http://domination.sourceforge.net"
SRC_URI="mirror://sourceforge/domination/Domination_${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S=${WORKDIR}/Domination

pkg_setup() {
	games_pkg_setup
	java-pkg-2_pkg_setup
}

EANT_BUILD_TARGET="game"

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	newgamesbin "${S}"/FlashGUI.sh ${PN}
	sed -i \
		-e "s|cd.*|cd \"${GAMES_DATADIR}\"/${PN}|" \
		"${D}${GAMES_BINDIR}"/${PN} \
		|| die
	chmod +x "${D}${GAMES_BINDIR}"/${PN} || die

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r "${S}"/*
	rm -f "${D}${GAMES_DATADIR}"/${PN}/*.cmd || die
	java-pkg_regjar "${D}/${GAMES_DATADIR}/${PN}"/*.jar

	newicon resources/icon.png ${PN}.png
	make_desktop_entry ${PN} "Domination"

	prepgamesdirs
}
