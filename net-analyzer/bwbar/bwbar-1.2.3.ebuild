# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="The kernel.org \"Current bandwidth utilization\" bar"
HOMEPAGE="https://www.kernel.org/pub/software/web/bwbar/"
SRC_URI="https://www.kernel.org/pub/software/web/bwbar/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=media-libs/libpng-1.2"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch
}

src_install() {
	dobin bwbar
	dodoc README
}
