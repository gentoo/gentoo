# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Nice graphical accompaniment to music"
HOMEPAGE="https://www.logarithmic.net/pfh/synaesthesia"
SRC_URI="https://www.logarithmic.net/pfh-files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	x11-libs/libX11
	|| ( media-libs/libsdl
		media-libs/svgalib )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-respect-flags.patch
	"${FILESDIR}"/${P}-inline-keyword.patch
	"${FILESDIR}"/${P}-dropping-register.patch
)
