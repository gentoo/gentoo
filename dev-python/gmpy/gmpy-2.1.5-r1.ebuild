# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="gmpy2"
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="
	https://github.com/aleaxit/gmpy/
	https://pypi.org/project/gmpy2/
"
SRC_URI="${SRC_URI}
	https://dev.gentoo.org/~grozin/${P}-py3.12.patch.gz"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_sphinx docs

src_prepare() {
	eapply "${WORKDIR}"/${P}-py3.12.patch
	distutils-r1_src_prepare
}

python_test() {
	cd test || die
	"${EPYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}
