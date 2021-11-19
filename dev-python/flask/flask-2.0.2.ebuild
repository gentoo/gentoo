# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A microframework based on Werkzeug, Jinja2 and good intentions"
HOMEPAGE="https://github.com/pallets/flask/"
MY_PN="Flask"
MY_P="${MY_PN}-${PV}"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mitsuhiko/flask.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 arm ~arm64 ~ia64 ppc ppc64 ~riscv ~s390 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples"

RDEPEND="
	>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-2.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		>=dev-python/asgiref-3.2[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinx-issues \
	dev-python/sphinx-tabs \
	dev-python/sphinxcontrib-log_cabinet
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		# https://github.com/pallets/flask/issues/4292
		# (test xfailed in newer version)
		tests/test_cli.py::test_lazy_load_error
	)

	epytest -p no:httpbin
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
