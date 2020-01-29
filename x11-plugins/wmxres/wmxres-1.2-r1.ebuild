# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Dock application to select your display mode among those possible"
HOMEPAGE="http://yalla.free.fr/wn"
SRC_URI="http://yalla.free.fr/wn/${PN}-1.1-0.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXxf86dga"

S="${WORKDIR}/${PN}.app"

PATCHES=(
	"${FILESDIR}"/${PN}-debian-1.1-1.2.patch
	"${FILESDIR}"/${PN}-1.2-r1-fix-build-system.patch
	"${FILESDIR}"/${P}-gcc-10.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}/${PN}
	doman ${PN}.1
}
