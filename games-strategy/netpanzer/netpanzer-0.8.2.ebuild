# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/netpanzer/netpanzer-0.8.2.ebuild,v 1.11 2015/02/18 19:08:13 mr_bones_ Exp $

EAPI=5
inherit eutils games

DATAVERSION="0.8"
DESCRIPTION="Fast-action multiplayer strategic network game"
HOMEPAGE="http://www.netpanzer.info/"
SRC_URI="mirror://sourceforge/netpanzer.berlios/${P}.tar.bz2
	mirror://sourceforge/netpanzer.berlios/${PN}-data-${DATAVERSION}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE="dedicated"

RDEPEND="dedicated? ( app-misc/screen )
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-image
	dev-games/physfs"
DEPEND="${RDEPEND}
	dev-util/ftjam"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc47.patch
}

src_configure() {
	egamesconf
	cd "${WORKDIR}"/${PN}-data-${DATAVERSION} \
		&& egamesconf
}

src_compile() {
	AR="${AR} cru" jam -q || die

	cd "${WORKDIR}"/${PN}-data-${DATAVERSION}
	jam -q || die
}

src_install() {
	jam -sDESTDIR="${D}" -sappdocdir=/usr/share/doc/${PF} install || die

	cd "${WORKDIR}"/${PN}-data-${DATAVERSION}
	jam -sDESTDIR="${D}" -sappdocdir=/usr/share/doc/${PF} install || die

	if use dedicated ; then
		newinitd "${FILESDIR}"/${PN}.rc ${PN}
		sed -i \
			-e "s:GAMES_USER_DED:${GAMES_USER_DED}:" \
			-e "s:GENTOO_DIR:${GAMES_BINDIR}:" \
			"${D}"/etc/init.d/${PN} || die

		insinto /etc
		doins "${FILESDIR}"/${PN}-ded.ini
		dogamesbin "${FILESDIR}"/${PN}-ded
		sed -i \
			-e "s:GENTOO_DIR:${GAMES_BINDIR}:" \
			"${D}/${GAMES_BINDIR}"/${PN}-ded || die
	fi

	rm -rf "${D}/${GAMES_DATADIR}"/{applications,pixmaps}
	doicon "${S}"/${PN}.png
	make_desktop_entry ${PN} NetPanzer
	prepgamesdirs
}
