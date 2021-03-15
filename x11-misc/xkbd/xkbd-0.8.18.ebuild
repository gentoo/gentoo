# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="onscreen soft keyboard for X11"
HOMEPAGE="https://github.com/mahatma-kaganovich/xkbd"
SRC_URI="https://github.com/mahatma-kaganovich/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="debug +xft +xpm"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
	xft? ( x11-libs/libXft )
	xpm? ( x11-libs/libXpm )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DOCS=( AUTHORS )
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use debug && append-cppflags -DDEBUG
	econf \
		$(use_enable xft) \
		$(use_enable xpm) \
		--disable-debug
}
