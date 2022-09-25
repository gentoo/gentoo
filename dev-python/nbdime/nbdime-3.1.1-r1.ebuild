# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Diff and merge of Jupyter Notebooks"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="webtools"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter_server[${PYTHON_USEDEP}]
	dev-python/jupyter_server_mathjax[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
	webtools? ( net-libs/nodejs[npm] )"
BDEPEND="
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs/source \
		dev-python/recommonmark \
		dev-python/sphinx_rtd_theme
distutils_enable_tests --install pytest

python_prepare_all() {
	# yield tests were removed in pytest 4.0
	sed -i -e 's/test_offline_mathjax/_&/' \
		-e 's/test_api_merge/_&/' \
		-e 's/test_fetch_merge/_&/' \
		-e 's/test_api_diff/_&/' \
		-e 's/test_fetch_diff/_&/' \
		nbdime/tests/test_web.py || die
	sed -i -e 's/test_git_difftool/_&/' \
		nbdime/tests/test_server_extension.py || die
	# reason: [NOTRUN] flaws in deep diffing of lists, not identifying almost equal sublists
	sed -i -e 's/test_deep_merge_lists_delete_no_conflict__currently_expected_failures/_&/' \
		nbdime/tests/test_merge.py || die
	sed -i -e 's/test_diff_to_json_patch/_&/' \
		nbdime/tests/test_diff_json_conversion.py || die
	sed -i -e 's/test_build_diffs_unsorted/_&/' \
		nbdime/tests/test_decision_tools.py || die
	sed -i -e 's/test_merge_multiline_cell_source_conflict/_&/' \
		-e 's/test_merge_interleave_cell_add_remove/_&/' \
		-e 's/test_merge_conflicts_get_diff_indices_shifted/_&/' \
		-e 's/test_merge_inserts_within_deleted_range/_&/' \
		nbdime/tests/test_merge_notebooks.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	use webtools || DISTUTILS_ARGS=( --skip-npm )
}

src_test() {
	# user.email and user.name are not configured in the sandbox
	git config --global user.email "larry@gentoo.org" || die
	git config --global user.name "Larry the Cow" || die

	distutils-r1_src_test
}
