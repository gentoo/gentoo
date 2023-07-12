# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bus scanning, testing and topology visualizing tool for Linux IEEE1394 subsystem"
HOMEPAGE="https://sourceforge.net/projects/gscanbus.berlios/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	sys-libs/libraw1394
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Wimplicit-function-declaration.patch
	"${FILESDIR}"/${P}-incompatible-function-pointer-types.patch

)
