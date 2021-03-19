# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Python documentation generator"
HOMEPAGE="https://www.sphinx-doc.org/
	https://github.com/sphinx-doc/sphinx"
SRC_URI="mirror://pypi/S/${PN^}/${P^}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc latex test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/alabaster-0.8[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	dev-python/imagesize[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/snowballstemmer-1.1[${PYTHON_USEDEP}]
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
BDEPEND="
	doc? (
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? (
		${RDEPEND}
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		virtual/imagemagick-tools[jpeg,png,svg]
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}/${PN}-3.2.1-doc-link.patch"
)

python_prepare_all() {
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

	local deselect=(
		# these tests require Internet access
		tests/test_build_latex.py::test_latex_images
		tests/test_build_linkcheck.py::test_defaults
		tests/test_build_linkcheck.py::test_defaults_json
		tests/test_build_linkcheck.py::test_anchors_ignored
	)
	[[ ${EPYTHON} == pypy3 ]] && deselect+=(
		tests/test_ext_autodoc.py::test_autodoc_inherited_members_None
		tests/test_ext_autodoc.py::test_automethod_for_builtin
		tests/test_ext_autodoc.py::test_partialfunction
		tests/test_ext_autodoc.py::test_autodoc_typed_instance_variables
		tests/test_ext_autodoc.py::test_autodoc_typed_inherited_instance_variables
		tests/test_ext_autodoc.py::test_cython
		tests/test_ext_autodoc_autoclass.py::test_show_inheritance_for_subclass_of_generic_type
		tests/test_ext_autodoc_autodata.py::test_autodata_type_comment
		tests/test_ext_autodoc_autofunction.py::test_builtin_function
		tests/test_ext_autodoc_autofunction.py::test_methoddescriptor
		tests/test_ext_autodoc_configs.py::test_autodoc_typehints_signature
		tests/test_ext_autodoc_configs.py::test_autodoc_type_aliases
		tests/test_ext_autosummary.py::test_autosummary_generate_content_for_module
		tests/test_ext_autosummary.py::test_autosummary_generate_content_for_module_skipped
		tests/test_pycode_parser.py::test_annotated_assignment_py36
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests fail with ${EPYTHON}"
}
