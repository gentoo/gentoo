# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Reimplementation of Nebulous using SDL"
HOMEPAGE="https://gitlab.com/roever/toppler/"
SRC_URI="mirror://sourceforge/toppler/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="acct-group/gamestat
	media-libs/libsdl[joystick,video]
	media-libs/sdl-mixer[vorbis]
	sys-libs/zlib
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-fix-docdir.patch
	"${FILESDIR}"/${P}-use-gamestat-group.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
