# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools desktop flag-o-matic

DESCRIPTION="Very polished Tetris clone"
HOMEPAGE="https://lgames.sourceforge.io/LTris/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	AT_M4DIR=m4 eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #570966)
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var/games \
		$(use_enable nls)
}

src_install() {
	default

	fowners 0:gamestat /usr/bin/${PN} /var/games/${PN}.hscr
	fperms g+s /usr/bin/${PN}
	fperms 664 /var/games/${PN}.hscr

	newicon icons/ltris48.xpm ${PN}.xpm
	make_desktop_entry ltris LTris
}
