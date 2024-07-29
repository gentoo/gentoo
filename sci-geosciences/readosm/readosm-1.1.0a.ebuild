# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to extract valid data from an Open Street Map input file"
HOMEPAGE="https://www.gaia-gis.it/fossil/readosm"
SRC_URI="https://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/expat
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
