# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV/_beta/b}"

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="https://github.com/aleaxit/gmpy"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-3+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-libs/mpc-1.0.2:=
	>=dev-libs/mpfr-3.1.2:=
	dev-libs/gmp:0=
"
DEPEND="${RDEPEND}"

PATCHES=(
	# In python 3.10 _PyHASH_NAN was removed and its usage replaced with _Py_HashPointer
	# see https://github.com/python/cpython/blob/3.10/Python/pyhash.c
	# https://github.com/aleaxit/gmpy/pull/297
	"${FILESDIR}"/${P}-pyhash-nan.patch
	# The tests program asks for input when running, disable that
	"${FILESDIR}"/${P}-test-input.patch
	# Based on this commit:
	# https://github.com/aleaxit/gmpy/commit/db7ce2ef46fab84e7b9c32b05725e9b02e8cf206
	"${FILESDIR}"/${P}-failed-tests.patch
)

distutils_enable_sphinx docs

python_test() {
	cd test || die
	"${EPYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}
