# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple XLS data extraction library"
HOMEPAGE="https://www.gaia-gis.it/fossil/freexl/index"
SRC_URI="https://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86"

DEPEND="
	dev-libs/expat
	sys-libs/zlib[minizip]
	virtual/libiconv
"
RDEPEND="${DEPEND}"

src_configure() {
	econf --enable-xmldocs
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
