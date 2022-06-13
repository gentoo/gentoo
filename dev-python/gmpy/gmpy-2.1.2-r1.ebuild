# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="
	https://github.com/aleaxit/gmpy/
	https://pypi.org/project/gmpy2/
"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	# The tests program asks for input when running, disable that
	"${FILESDIR}"/gmpy-2.1.0_beta5-test-input.patch
)

distutils_enable_sphinx docs

python_test() {
	cd test || die
	"${EPYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}
