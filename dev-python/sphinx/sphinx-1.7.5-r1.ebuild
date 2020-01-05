# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python documentation generator"
HOMEPAGE="http://www.sphinx-doc.org/"
SRC_URI="mirror://pypi/S/${PN^}/${P^}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="doc latex net test"

# Tests automagically use latex, bug 667414
#REQUIRED_USE="test? ( latex )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/alabaster-0.7.9[${PYTHON_USEDEP}]
	<dev-python/alabaster-0.8[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	dev-python/imagesize[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	>=dev-python/snowballstemmer-1.1[${PYTHON_USEDEP}]
	>=dev-python/sphinx_rtd_theme-0.1[${PYTHON_USEDEP}]
	<dev-python/sphinx_rtd_theme-2.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	latex? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)
	net? (
		>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
		virtual/imagemagick-tools[jpeg,png,svg]
		virtual/python-enum34[${PYTHON_USEDEP}]
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)"

S="${WORKDIR}/${P^}"

python_prepare_all() {
	# remove tests that fail due to network-sandbox
	rm tests/test_websupport.py || die "Failed to remove web tests"
	rm tests/test_build_linkcheck.py || die "Failed to remove web tests"
	sed -i -e 's:test_latex_remote_images:_&:' tests/test_build_latex.py || die

	# fails when additional sphinx themes are installed
	sed -i -e 's:test_theme_api:_&:' tests/test_theming.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile

	# Generate the grammar. It will be caught by install somehow.
	# Note that the tests usually do it for us. However, I don't want
	# to trust USE=test really running all the tests, especially
	# with FEATURES=test-fail-continue.
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	"${EPYTHON}" -m sphinx.pycode.__init__ || die "Grammar generation failed."
	popd >/dev/null || die
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
		HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	fi
}

python_test() {
	mkdir -p "${BUILD_DIR}/sphinx_tempdir" || die
	local -x SPHINX_TEST_TEMPDIR="${BUILD_DIR}/sphinx_tempdir"
	py.test -vv || die "Tests fail with ${EPYTHON}"
}
