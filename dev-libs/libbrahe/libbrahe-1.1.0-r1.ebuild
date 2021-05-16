# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A Heterogenous C Library of Numeric Functions"
HOMEPAGE="http://www.coyotegulch.com/products/brahe/"
SRC_URI="http://www.coyotegulch.com/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

DOCS=( AUTHORS ChangeLog NEWS )

PATCHES=(
	"${FILESDIR}/${PV}-missing_libs.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.a' -delete || die
}
