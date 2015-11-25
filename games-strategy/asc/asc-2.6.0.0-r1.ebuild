# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER=3.0
inherit eutils toolchain-funcs flag-o-matic wxwidgets games

DESCRIPTION="turn based strategy game designed in the tradition of the Battle Isle series"
HOMEPAGE="http://www.asc-hq.org/"
SRC_URI="mirror://sourceforge/asc-hq/${P}.tar.bz2
	http://www.asc-hq.org/music/frontiers.ogg
	http://www.asc-hq.org/music/time_to_strike.ogg
	http://www.asc-hq.org/music/machine_wars.ogg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="app-arch/bzip2
	media-libs/libsdl[video]
	media-libs/libpng:0
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-sound
	dev-libs/boost
	dev-games/physfs
	media-libs/xvid
	dev-libs/expat
	media-libs/freetype
	dev-lang/lua:0
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	dev-libs/libsigc++:1.2"

DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	app-arch/zip"

src_unpack() {
	local f

	unpack ${P}.tar.bz2
	for f in ${A}
	do
		case ${f} in
		*ogg)
			cp "${DISTDIR}/${f}" "${S}/data/music" || die
			;;
		esac
	done
}

src_configure() {
	need-wxwidgets unicode
	# Added --disable-paraguitest for bugs 26402 and 4488
	# Added --disable-paragui for bug 61154 since it's not really used much
	# and the case is well documented at http://www.asc-hq.org/
	if [[ $(gcc-major-version) -eq 4 ]] ; then
		replace-flags -O3 -O2
	fi
	egamesconf \
		--disable-paraguitest \
		--disable-paragui \
		--datadir="${GAMES_DATADIR_BASE}"
}

src_install() {
	default
	dohtml -r doc/*
	prepgamesdirs
}
