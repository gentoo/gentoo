# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/torcs/torcs-1.3.6.ebuild,v 1.3 2015/02/10 10:11:49 ago Exp $

EAPI=5
inherit autotools eutils multilib games

DESCRIPTION="The Open Racing Car Simulator"
HOMEPAGE="http://torcs.sourceforge.net/"
SRC_URI="mirror://sourceforge/torcs/${P}.tar.bz2"

LICENSE="GPL-2 FreeArt"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/freealut
	media-libs/freeglut
	media-libs/libpng:0
	media-libs/libvorbis:=
	media-libs/openal
	>=media-libs/plib-1.8.5
	sys-libs/zlib:0=
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-no-automake.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-flags.patch \
		"${FILESDIR}"/${P}-noXmuXt.patch
	eautoreconf
	ecvs_clean
}

src_configure() {
	addpredict $(echo /dev/snd/controlC? | sed 's/ /:/g')
	[[ -e /dev/dsp ]] && addpredict /dev/dsp
	egamesconf \
		--datadir="${GAMES_DATADIR_BASE}" \
		--x-libraries=/usr/$(get_libdir) \
		--enable-xrandr
}

src_compile() {
	# So ugly... patches welcome.
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install datainstall
	newicon Ticon.png ${PN}.png
	make_desktop_entry ${PN} TORCS
	dodoc README doc/history/history.txt
	doman doc/man/*.6
	dohtml -r doc/faq/faq.html doc/tutorials doc/userman
	prepgamesdirs
}
