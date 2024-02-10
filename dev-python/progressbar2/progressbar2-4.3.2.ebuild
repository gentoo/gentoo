# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Text progressbar library for python"
HOMEPAGE="
	https://progressbar-2.readthedocs.io/
	https://github.com/WoLpH/python-progressbar/
	https://pypi.org/project/progressbar2/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

RDEPEND="
	>=dev-python/python-utils-3.8.1[${PYTHON_USEDEP}]
	!dev-python/progressbar
"
BDEPEND="
	test? (
		>=dev-python/dill-0.3.6[${PYTHON_USEDEP}]
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/cov/d' pytest.ini || die
	default
}

python_test() {
	local -x PYTHONDONTWRITEBYTECODE=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
