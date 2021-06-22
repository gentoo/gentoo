# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Yamaha DX7 modeling DSSI plugin"
HOMEPAGE="http://smbolton.com/hexter.html"
SRC_URI="https://github.com/smbolton/${PN}/releases/download/version_${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="readline"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	media-libs/alsa-lib
	media-libs/dssi
	media-libs/liblo
	readline? (
		sys-libs/ncurses:0=
		sys-libs/readline:0=
	)
"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
"

src_configure() {
	PKG_CONFIG=pkg-config \
	econf --without-gtk2 \
		$(use_with readline textui)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
