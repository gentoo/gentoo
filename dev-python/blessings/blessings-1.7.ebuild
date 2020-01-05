# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="A thin, practical wrapper around terminal coloring, styling, and positioning"
HOMEPAGE="https://github.com/erikrose/blessings https://pypi.org/project/blessings/"
# https://github.com/erikrose/blessings/pull/136
SRC_URI="https://github.com/erikrose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		sphinx-build docs/ docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# The tests need an interactive terminal
	# https://github.com/erikrose/blessings/issues/117
	script -eqc "nosetests -v -w \"${BUILD_DIR}\"" /dev/null \
		|| die "tests failed with ${EPYTHON}"
}
