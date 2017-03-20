# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A very simple command line utility for changing X resolutions"
HOMEPAGE="http://hpwww.ec-lyon.fr/~vincent/"
SRC_URI="http://hpwww.ec-lyon.fr/~vincent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXxf86dga
	x11-libs/libXext
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto
	x11-proto/xf86dgaproto"

PATCHES=( "${FILESDIR}"/${P}-{flags,includes}.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin chgres
	einstalldocs
}
