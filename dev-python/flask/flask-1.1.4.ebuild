# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="<dev-python/click-8[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	<dev-python/itsdangerous-2[${PYTHON_USEDEP}]
	<dev-python/jinja-3[${PYTHON_USEDEP}]
	<dev-python/werkzeug-2[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs

python_test() {
	distutils_install_for_testing
	PYTHONPATH=${S}/examples/flaskr:${S}/examples/minitwit${PYTHONPATH:+:${PYTHONPATH}} \
		pytest -vv -p no:httpbin || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
