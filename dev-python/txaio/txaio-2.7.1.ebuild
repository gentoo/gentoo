# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE="https://github.com/crossbario/txaio https://pypi.org/project/txaio/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/trollius-2.0[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '>=dev-python/futures-3.0.3[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-spelling-2.1.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-0.1.9[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
		~dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/pyenchant-1.6.6[${PYTHON_USEDEP}]
	)
"

# py 3.6 upstream bug fixes applied just after the release
PATCHES=(
	"${FILESDIR}/txaio-2.7.1.f._result.patch"
	"${FILESDIR}/txaio-2.7.1.chained-callback.patch"
)

src_prepare() {
	default_src_prepare
	# Take out failing tests known to pass when run manually
	# we certainly don't need to test "python setup.py sdist" here
	rm "${S}/test/test_packaging.py" || die
}

python_prepare() {
	# https://github.com/tavendo/txaio/issues/3
	cp -r "${FILESDIR}"/util.py test || die

	distutils-r1_python_prepare
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
