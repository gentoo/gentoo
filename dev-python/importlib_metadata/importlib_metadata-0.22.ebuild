# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7}} )

inherit distutils-r1

DESCRIPTION="Read metadata from Python packages"
HOMEPAGE="https://importlib-metadata.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/zipp[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/configparser-3.5[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' -2)
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' pypy pypy3 python2_7 python3_5 python3_6)
		dev-python/packaging[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
python_prepare_all() {
	sed -i "/'sphinx.ext.intersphinx'/d" ${PN}/docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build ${PN}/docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "tests failed with ${EPYTHON}"
}
