# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Correctly inflect words and numbers"
HOMEPAGE="https://github.com/jazzband/inflect"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' pypy3 python3_{6,7})
"
# six can be removed in the next release
# https://github.com/jazzband/inflect/commit/407dfa7e170a562012f37e9bd65c3b50cd3da0cb
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs '>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9' dev-python/alabaster

python_test() {
	# Override pytest options to skip flake8
	pytest -vv tests --override-ini="addopts=--doctest-modules" \
		|| die "tests failed with ${EPYTHON}"
}
