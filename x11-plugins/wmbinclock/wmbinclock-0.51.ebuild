# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="a nifty little binary clock dockapp"
HOMEPAGE="https://www.dockapps.net/wmbinclock"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${PN}-0.5-gcc-10.patch )
DOCS=( CHANGELOG README.md )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		INCDIR="-I/usr/include/X11" LIBDIR="" \
		SYSTEM="${LDFLAGS}"
}

src_install() {
	dobin wmBinClock
	einstalldocs
}
