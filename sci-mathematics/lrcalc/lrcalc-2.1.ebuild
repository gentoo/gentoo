# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Littlewood-Richardson Calculator"
HOMEPAGE="https://sites.math.rutgers.edu/~asbuch/lrcalc/"
SRC_URI="https://sites.math.rutgers.edu/~asbuch/lrcalc/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/2"
KEYWORDS="amd64 ~riscv ~x86 ~x64-macos"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
