# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A microframework based on Werkzeug, Jinja2 and good intentions"
HOMEPAGE="
	https://palletsprojects.com/p/flask/
	https://github.com/pallets/flask/
	https://pypi.org/project/Flask/
"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mitsuhiko/flask.git"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples"

RDEPEND="
	>=dev-python/blinker-1.6.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-3.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/asgiref-3.2[${PYTHON_USEDEP}]
		!!dev-python/shiboken2[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinx-issues \
	dev-python/sphinx-tabs \
	dev-python/sphinxcontrib-log-cabinet
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
