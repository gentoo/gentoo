# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} pypy )

inherit distutils-r1

DESCRIPTION="Tools to provide lightweight pipelining in Python"
HOMEPAGE="https://joblib.readthedocs.io/en/latest/
	https://github.com/joblib/joblib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c doc/ doc/ doc/html || die "docs failed installation"
	fi
}

python_test() {
	# https://github.com/joblib/joblib/issues/143
	if [[ "${EPYTHON}" == pypy ]]; then
		sed -e 's:test_func_inspect_errors:_&:' -i ${PN}/test/test_func_inspect.py || die
		sed -e 's:test_parallel_pickling:_&:' -i ${PN}/test/test_parallel.py || die
	fi

	py.test -v
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
