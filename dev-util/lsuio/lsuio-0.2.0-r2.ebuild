# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="List available userspace I/O (UIO) devices"
HOMEPAGE="https://www.osadl.org/UIO.uio.0.html"
SRC_URI="https://www.osadl.org/uploads/media/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-build.patch" )

src_prepare() {
	default
	# https://bugs.gentoo.org/898772
	eautoreconf
}
