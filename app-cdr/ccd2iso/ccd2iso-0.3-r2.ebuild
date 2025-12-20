# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Convert CD images from ccd (CloneCD) to iso"
HOMEPAGE="https://sourceforge.net/projects/ccd2iso/"
SRC_URI="https://downloads.sourceforge.net/ccd2iso/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x64-macos"

PATCHES=( "${FILESDIR}"/${P}-headers.patch )

src_prepare() {
	default
	#C99 https://bugs.gentoo.org/900126
	eautoreconf
}
