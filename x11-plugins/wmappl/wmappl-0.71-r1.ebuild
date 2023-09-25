# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Simple application launcher for the Window Maker dock"
HOMEPAGE="https://www.dockapps.net/wmappl"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

src_prepare() {
	rm -rf "${S}"/icons/CVS || die
	default
	eautoreconf
}
