# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Wayv is hand-writing/gesturing recognition software for X"
HOMEPAGE="http://www.stressbunny.com/wayv"
SRC_URI="http://www.stressbunny.com/gimme/wayv/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.3-autoconf.patch
	"${FILESDIR}"/${PN}-0.3-flags.patch
	"${FILESDIR}"/${PN}-0.3-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	cd doc
	default
	dodoc HOWTO*
}
