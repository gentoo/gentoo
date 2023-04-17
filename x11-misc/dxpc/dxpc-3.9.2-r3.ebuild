# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Differential X Protocol Compressor"
HOMEPAGE="http://www.vigor.nu/dxpc/"
SRC_URI="http://www.vigor.nu/dxpc/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

RDEPEND="
	x11-libs/libXt
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )
DOCS=( CHANGES README TODO )
