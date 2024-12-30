# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Genomic similarity search with multiple transition constrained spaced seeds"
HOMEPAGE="http://bioinfo.lifl.fr/yass/"
SRC_URI="http://bioinfo.lifl.fr/yass/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lowmem threads"

PATCHES=( "${FILESDIR}"/${PV}-as-needed.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable threads) \
		$(use_enable lowmem lowmemory) \
		--without-dmalloc
}
