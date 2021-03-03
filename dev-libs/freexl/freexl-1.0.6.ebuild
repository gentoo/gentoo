# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple XLS data extraction library"
HOMEPAGE="https://www.gaia-gis.it/fossil/freexl/index"
SRC_URI="https://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ppc64 x86"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
