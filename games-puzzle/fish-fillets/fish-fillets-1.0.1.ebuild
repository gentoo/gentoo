# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DATA_PV="1.0.0"
DESCRIPTION="Underwater puzzle game - find a safe way out"
HOMEPAGE="http://fillets.sourceforge.net/"
SRC_URI="mirror://sourceforge/fillets/fillets-ng-${PV}.tar.gz
	mirror://sourceforge/fillets/fillets-ng-data-${DATA_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2[sound,video]
	>=media-libs/sdl-mixer-1.2.5[vorbis]
	>=media-libs/sdl-image-1.2.2[png]
	media-libs/smpeg
	x11-libs/libX11
	media-libs/sdl-ttf
	dev-libs/fribidi
	>=dev-lang/lua-5"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/fillets-ng-${PV}

src_prepare() {
	#.mod was renamed to .fmod in lua 5.1.3 - bug #223271
	sed -i \
		-e 's/\.mod(/.fmod(/' \
		$(grep -rl "\.mod\>" "${WORKDIR}"/fillets-ng-data-${DATA_PV}) \
		|| die "sed failed"
	rm -f missing
	eautoreconf
}

src_configure() {
	egamesconf \
		--datadir="${GAMES_DATADIR}/${PN}"
}

src_install() {
	default
	insinto "${GAMES_DATADIR}/${PN}"
	cd "${WORKDIR}"/fillets-ng-data-${DATA_PV} || die
	rm -f COPYING
	doins -r *
	newicon images/icon.png ${PN}.png
	make_desktop_entry fillets "Fish Fillets NG"
	prepgamesdirs
}
