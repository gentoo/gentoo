# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python documentation generator"
HOMEPAGE="https://www.sphinx-doc.org/
	https://github.com/sphinx-doc/sphinx"
SRC_URI="mirror://pypi/S/${PN^}/${P^}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="doc latex test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/alabaster-0.8[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/imagesize[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/snowballstemmer[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-applehelp[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-devhelp[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-jsmath[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-htmlhelp[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-serializinghtml[${PYTHON_USEDEP}]
	dev-python/sphinxcontrib-qthelp[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typed-ast[${PYTHON_USEDEP}]
	' python3_{6,7})
	latex? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? (
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		virtual/imagemagick-tools[jpeg,png,svg]
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)"

S="${WORKDIR}/${P^}"

python_prepare_all() {
	# remove tests that fail due to network-sandbox
	rm tests/test_build_linkcheck.py || die "Failed to remove web tests"
	sed -i -e 's:test_latex_images:_&:' tests/test_build_latex.py || die

	# fail under pypy3 (some because of missing typed-ast)
	# revisit when pypy3 becomes pypy3.8
	sed -i -e '/def test_partialfunction/i\
@pytest.mark.skipif(hasattr(sys, "pypy_version_info"), reason="broken on pypy3")' \
		-e '/def test_autodoc_typed_instance_variables/i\
@pytest.mark.skipif(hasattr(sys, "pypy_version_info"), reason="broken on pypy3")' \
		-e '/def test_autodoc_inherited_members_None/i\
@pytest.mark.skipif(hasattr(sys, "pypy_version_info"), reason="broken on pypy3")' \
		-e '/def test_cython/i\
@pytest.mark.skipif(hasattr(sys, "pypy_version_info"), reason="broken on pypy3")' \
		tests/test_autodoc.py || die
	sed -i -e '11aimport sys' \
		-e '/def test_autodoc_typehints_signature/i\
@pytest.mark.skipif(hasattr(sys, "pypy_version_info"), reason="broken on pypy3")' \
		tests/test_ext_autodoc_configs.py || die
	sed -i -e '/def test_annotated_assignment_py36/i\
@pytest.mark.skipif(hasattr(sys, "pypy_version_info"), reason="broken on pypy3")' \
		tests/test_pycode_parser.py || die

	# disable internet access
	sed -i -e 's:^intersphinx_mapping:disabled_&:' \
		doc/conf.py || die

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
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
