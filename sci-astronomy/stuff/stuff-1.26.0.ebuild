# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool for automatic generation of astronomical catalogs"
HOMEPAGE="http://www.astromatic.net/software/stuff/"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	econf $(use_enable threads)
}
