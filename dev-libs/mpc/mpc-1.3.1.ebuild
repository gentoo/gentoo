# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/mpc.asc
inherit multilib-minimal verify-sig

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding"
HOMEPAGE="https://www.multiprecision.org/mpc/ https://gitlab.inria.fr/mpc/mpc"

if [[ ${PV} == *_rc* ]] ; then
	SRC_URI="https://www.multiprecision.org/downloads/${P/_}.tar.gz"
	S="${WORKDIR}"/${PN}-$(ver_cut 1-3)
else
	SRC_URI="
		mirror://gnu/${PN}/${P}.tar.gz
		verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )
	"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

LICENSE="LGPL-3+ FDL-1.3+"
SLOT="0/3" # libmpc.so.3
IUSE="static-libs"

DEPEND="
	>=dev-libs/gmp-5.0.0:=[${MULTILIB_USEDEP},static-libs?]
	>=dev-libs/mpfr-4.1.0:=[${MULTILIB_USEDEP},static-libs?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-mpc )
"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
