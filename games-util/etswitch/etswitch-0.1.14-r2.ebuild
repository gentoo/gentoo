# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="*nix minimizer for a few games"
HOMEPAGE="http://hem.bredband.net/b400150/"
SRC_URI="http://hem.bredband.net/b400150/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/libXmu
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-desktop-entry.patch
	"${FILESDIR}"/${P}-glibc.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	eautoreconf
}
