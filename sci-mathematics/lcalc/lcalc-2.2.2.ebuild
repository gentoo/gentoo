# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit libtool

DESCRIPTION="Command-line utility and library for L-function computations"
HOMEPAGE="https://gitlab.com/sagemath/lcalc"
SRC_URI="https://gitlab.com/-/project/12934202/uploads/79611ba9b2a4ca214df935f43978e2de/${P}.tar.xz"

LICENSE="GPL-2+"
# The subslot is the libLfunction soname major version
SLOT="0/2"
KEYWORDS="~amd64 ~riscv"

# Omit USE=mpfr and USE=openmp for now because they're broken upstream:
#
#   https://gitlab.com/sagemath/lcalc/-/work_items/7
#   https://gitlab.com/sagemath/lcalc/-/work_items/13
#
IUSE="+double double-double quad-double pari"
REQUIRED_USE="^^ ( double double-double quad-double )"

BDEPEND="dev-util/gengetopt"
DEPEND="double-double? ( sci-libs/qd:= )
	quad-double? ( sci-libs/qd:= )
	pari? ( sci-mathematics/pari:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Attempt to fix bug 953363 (using the fix for bug 914068)
	elibtoolize
}

src_configure() {
	econf $(use_with pari) \
		  --enable-precision="$(usev double)$(usev double-double)$(usev quad-double)"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
