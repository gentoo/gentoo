# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line utility and library for L-function computations"
HOMEPAGE="https://gitlab.com/sagemath/lcalc"
SRC_URI="https://gitlab.com/sagemath/lcalc/uploads/25f029f3c02fcb6c3174972e0ac0e192/${P}.tar.xz"

LICENSE="GPL-2+"
# The subslot is the libLfunction soname major version
SLOT="0/1"
KEYWORDS="amd64"

# Omit USE=mpfr for now because it's broken upstream:
#
#   https://gitlab.com/sagemath/lcalc/-/issues/7
#
IUSE="+double double-double quad-double pari"
REQUIRED_USE="^^ ( double double-double quad-double )"

BDEPEND="dev-util/gengetopt"
DEPEND="double-double? ( sci-libs/qd:= )
	quad-double? ( sci-libs/qd:= )
	pari? ( sci-mathematics/pari:= )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with pari) \
		  --enable-precision="$(usev double)$(usev double-double)$(usev quad-double)"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
