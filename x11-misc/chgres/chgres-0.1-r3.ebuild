# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A very simple command line utility for changing X resolutions"
HOMEPAGE="http://hpwww.ec-lyon.fr/~vincent/"
SRC_URI="http://hpwww.ec-lyon.fr/~vincent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXxf86dga
	x11-libs/libXext
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-includes.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin chgres
	einstalldocs
}
