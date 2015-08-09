# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="Fly a plane around bomb/shoot the enemy. Port of Planegame from Amiga"
HOMEPAGE="http://www.fishies.org.uk/apricots.html"
SRC_URI="http://www.fishies.org.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/openal
	media-libs/freealut"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-freealut.patch \
		"${FILESDIR}"/${P}-ldflags.patch

	cp admin/acinclude.m4.in acinclude.m4

	sed -i \
		-e 's:-DAP_PATH=\\\\\\"$prefix.*":-DAP_PATH=\\\\\\"${GAMES_DATADIR}/${PN}/\\\\\\"":' \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' \
		configure.in || die
	sed -i \
		-e "s:filename(AP_PATH):filename(\"${GAMES_SYSCONFDIR}/${PN}/\"):" \
		${PN}/init.cpp || die
	sed -i \
		-e "s:apricots.cfg:${GAMES_SYSCONFDIR}/${PN}/apricots.cfg:" \
		README apricots.html || die
	sed -i \
		-e 's/-Wmissing-prototypes//' \
		acinclude.m4 || die
	eautoreconf
}

src_compile() {
	emake LIBTOOL="/usr/bin/libtool"
}

src_install() {
	dodoc AUTHORS README TODO ChangeLog
	dohtml apricots.html
	cd ${PN}
	dogamesbin apricots
	insinto "${GAMES_DATADIR}"/${PN}
	doins *.wav *.psf *.shapes
	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins apricots.cfg
	make_desktop_entry ${PN} Apricots
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You can change the game options by editing:"
	elog "${GAMES_SYSCONFDIR}/${PN}/apricots.cfg"
}
