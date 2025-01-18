# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature

DESCRIPTION="A library for Python file locking"
HOMEPAGE="
	https://github.com/WoLpH/portalocker/
	https://portalocker.readthedocs.io/
	https://pypi.org/project/portalocker/
"
SRC_URI="
	https://github.com/WoLpH/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="
	test? (
		dev-python/redis[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-15.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-6.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	# Disable code coverage in tests.
	sed -i '/^ *--cov.*$/d' pytest.ini || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p rerunfailures
}

pkg_postinst() {
	optfeature "redis support" dev-python/redis
}
