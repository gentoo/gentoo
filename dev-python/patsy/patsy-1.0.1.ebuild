# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python module to describe statistical models and design matrices"
HOMEPAGE="
	https://patsy.readthedocs.io/en/latest/index.html
	https://github.com/pydata/patsy/
	https://pypi.org/project/patsy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	!hppa? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
