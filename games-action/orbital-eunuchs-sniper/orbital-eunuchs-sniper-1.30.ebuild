# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/orbital-eunuchs-sniper/orbital-eunuchs-sniper-1.30.ebuild,v 1.7 2015/02/06 13:41:19 ago Exp $

EAPI=5
inherit autotools eutils games

MY_P=${PN//-/_}-${PV}
DESCRIPTION="Snipe terrorists from your orbital base"
HOMEPAGE="http://icculus.org/oes/"
SRC_URI="http://filesingularity.timedoctor.org/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-datadir.patch \
		"${FILESDIR}"/${P}-gcc43.patch
	sed -i \
		-e '/^sleep /d' \
		configure.ac || die
	eautoreconf
}

src_install() {
	DOCS="AUTHORS ChangeLog readme.txt README TODO" \
		default
	make_desktop_entry snipe2d "Orbital Eunuchs Sniper"
	prepgamesdirs
}
