# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN="gmpy2"
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="
	https://github.com/aleaxit/gmpy/
	https://pypi.org/project/gmpy2/
"
SRC_URI+="
	https://dev.gentoo.org/~grozin/${P}-py3.12.patch.gz
	https://github.com/tornaria/void-packages/raw/722b32aa405804b79a74256708de6a511e255b4b/srcpkgs/python3-gmpy2/patches/cleanup-object-caching.patch
		-> ${P}-cache.patch
"

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha ~amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_sphinx docs

PATCHES=(
	"${WORKDIR}/${P}-py3.12.patch"
	# https://github.com/aleaxit/gmpy/commit/7351e2eb1abf4b37a47a822eb3f3f29f90c7f854
	# rebased by Void; needed for mpfr 4.2.1
	"${DISTDIR}/${P}-cache.patch"
	# https://github.com/aleaxit/gmpy/commit/68a6b489c3d8d95b2658a1ed884fb99f4bd955c1
	"${FILESDIR}/${P}-mpfr-4.2.1.patch"
)

python_test() {
	cd test || die
	"${EPYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}
