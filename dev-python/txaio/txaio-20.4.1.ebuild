# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE="https://github.com/crossbario/txaio https://pypi.org/project/txaio/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-spelling-2.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-0.1.9[${PYTHON_USEDEP}]
	)
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
		>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	default_src_prepare
	# Take out failing tests known to pass when run manually
	# we certainly don't need to test "python setup.py sdist" here
	rm "${S}/test/test_packaging.py" || die
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	pytest -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
