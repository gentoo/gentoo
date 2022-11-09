# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Calculate speeds, equilibrium arguments, node factors of tidal constituents"
HOMEPAGE="https://flaterco.com/xtide/files.html"
SRC_URI="https://flaterco.com/files/xtide/${P}-r2.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND=">=sci-geosciences/libtcd-2.2.3"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
