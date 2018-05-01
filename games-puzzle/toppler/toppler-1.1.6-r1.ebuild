# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Reimplementation of Nebulous using SDL"
HOMEPAGE="http://toppler.sourceforge.net/"
SRC_URI="mirror://sourceforge/toppler/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	econf $(use_enable nls)
}
