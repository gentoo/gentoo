# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding"
HOMEPAGE="https://www.multiprecision.org/mpc/ https://gitlab.inria.fr/mpc/mpc"

if [[ ${PV} == *_rc* ]] ; then
	SRC_URI="https://www.multiprecision.org/downloads/${P/_}.tar.gz"
	#S="${WORKDIR}"/${P/_}
	S="${WORKDIR}"/${PN}-$(ver_cut 1-3)
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

	#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="LGPL-2.1"
SLOT="0/3" # libmpc.so.3
IUSE="static-libs"
# 1.3.1_rc1 is identical to 1.3.0-r1 so just keyword it and later RCs
# contain further build fixes for consumers.
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="
	>=dev-libs/gmp-5.0.0:=[${MULTILIB_USEDEP},static-libs?]
	>=dev-libs/mpfr-4.1.0:=[${MULTILIB_USEDEP},static-libs?]
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
