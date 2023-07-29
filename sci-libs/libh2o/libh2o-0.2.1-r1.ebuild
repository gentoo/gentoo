# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library of routines for IF97 water & steam properties"
HOMEPAGE="https://github.com/projg2/libh2o/"
SRC_URI="https://github.com/projg2/libh2o/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

RDEPEND="!www-servers/h2o"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable debug)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
