# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="IRC client framework written in Python"
HOMEPAGE="https://github.com/jaraco/irc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/jaraco-functools-1.5[${PYTHON_USEDEP}]
	>=dev-python/jaraco-itertools-1.8[${PYTHON_USEDEP}]
	>=dev-python/tempora-1.6[${PYTHON_USEDEP}]
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	dev-python/jaraco-logging[${PYTHON_USEDEP}]
	dev-python/jaraco-stream[${PYTHON_USEDEP}]
	dev-python/jaraco-text[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/jaraco-packaging-3.2[${PYTHON_USEDEP}]
		>=dev-python/rst-linker-1.9[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/backports-unittest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build . _build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# Override pytest options to skip flake8
	pytest -vv --override-ini="addopts=--doctest-modules" \
		|| die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/scripts"
		dodoc -r scripts
	fi
	distutils-r1_python_install_all
}
