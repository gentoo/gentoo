# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 eutils versionator

DESCRIPTION="Python documentation generator"
HOMEPAGE="http://sphinx.pocoo.org/ https://pypi.python.org/pypi/Sphinx"
SRC_URI="mirror://pypi/S/${PN^}/${P^}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~x86"
IUSE="doc latex net test"

RDEPEND="
	>=dev-python/alabaster-0.7.9[${PYTHON_USEDEP}]
	<dev-python/alabaster-0.8[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.1.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/snowballstemmer-1.1[${PYTHON_USEDEP}]
	>=dev-python/sphinx_rtd_theme-0.1[${PYTHON_USEDEP}]
	<dev-python/sphinx_rtd_theme-2.0[${PYTHON_USEDEP}]
	dev-python/imagesize[${PYTHON_USEDEP}]
	latex? (
		dev-texlive/texlive-latexextra
		app-text/dvipng
	)
	net? (
		>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/simplejson[${PYTHON_USEDEP}]' pypy)
		dev-python/html5lib[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
		>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'pypy*' 'python2*')
		$(python_gen_cond_dep 'dev-python/typing[${PYTHON_USEDEP}]' 'pypy*' 'python2*' python3_4 )
	)"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.1-fix-pycode-grammar.patch
)

python_prepare_all() {
	# remove tests that fail due to network-sandbox
	rm tests/test_websupport.py || die "Failed to remove web tests"
	rm tests/test_searchadapters.py || die "Failed to remove web tests"
	rm tests/test_build_linkcheck.py || die "Failed to remove web tests"

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
		emake -C doc SPHINXBUILD='"${EPYTHON}" "${S}/sphinx-build.py"' html
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	mkdir -p "${BUILD_DIR}/sphinx_tempdir" || die
	local -x SPHINX_TEST_TEMPDIR="${BUILD_DIR}/sphinx_tempdir"
	cp -r -l tests "${BUILD_DIR}"/ || die "Failed to copy tests"
	cp Makefile "${BUILD_DIR}"/ || die "Failed to copy Makefile"
	emake test
}

pkg_postinst() {
	replacing_python_eclass() {
		local pv
		for pv in ${REPLACING_VERSIONS}; do
			if ! version_is_at_least 1.1.3-r4 ${pv}; then
				return 0
			fi
		done

		return 1
	}

	if replacing_python_eclass; then
		ewarn "Replaced a very old sphinx version. If you are"
		ewarn "experiencing problems, please re-emerge sphinx."
	fi
}
