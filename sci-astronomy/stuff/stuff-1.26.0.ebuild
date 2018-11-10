# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool for automatic generation of astronomical catalogs"
HOMEPAGE="http://www.astromatic.net/software/stuff/"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-3"
SLOT="0"
IUSE="threads"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable threads)
}
