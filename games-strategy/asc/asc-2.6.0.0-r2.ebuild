# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER=3.0
inherit eutils toolchain-funcs flag-o-matic wxwidgets

DESCRIPTION="turn based strategy game designed in the tradition of the Battle Isle series"
HOMEPAGE="http://www.asc-hq.org/"
SRC_URI="mirror://sourceforge/asc-hq/${P}.tar.bz2
	http://www.asc-hq.org/music/frontiers.ogg
	http://www.asc-hq.org/music/time_to_strike.ogg
	http://www.asc-hq.org/music/machine_wars.ogg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/bzip2
	dev-games/physfs
	dev-lang/lua:0
	dev-libs/boost
	dev-libs/expat
	dev-libs/libsigc++:1.2
	media-libs/libpng:0
	media-libs/libsdl[video]
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-sound
	media-libs/freetype
	media-libs/xvid
	x11-libs/wxGTK:${WX_GTK_VER}[X]"

DEPEND="${RDEPEND}
	app-arch/zip
	dev-lang/perl
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/"/${P}-gcc6-nothrow-in-dtors.patch )

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
	econf \
		--disable-paraguitest \
		--disable-paragui \
		--datadir="/usr/share"
}

src_install() {
	default
	dodoc -r doc/*
}
