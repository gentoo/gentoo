# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Window Maker dock applet resembling a miniature pinboard"
HOMEPAGE="https://github.com/bbidulock/wmpinboard"
SRC_URI="https://github.com/bbidulock/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}/${P}-memcmp.patch" )

src_prepare() {
	default
	eautoreconf
}
