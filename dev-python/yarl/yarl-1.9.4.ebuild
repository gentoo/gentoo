# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Yet another URL library"
HOMEPAGE="
	https://github.com/aio-libs/yarl/
	https://pypi.org/project/yarl/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/expandvars[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	cd tests || die
	epytest --override-ini=addopts=
}
