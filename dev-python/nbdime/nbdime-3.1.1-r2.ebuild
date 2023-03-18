# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi edos2unix

DESCRIPTION="Diff and merge of Jupyter Notebooks"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/nbdime/
	https://pypi.org/project/nbdime/
"
SRC_URI+="
	https://github.com/jupyter/nbdime/commit/0e1cdaa77f57aa7f609d5ef7da26a52814c7ff74.patch
		-> ${P}-jupyter_server2.patch
	https://github.com/jupyter/nbdime/commit/f67a809262b45ed0eaedc840b0e5d979eaa6965d.patch
		-> ${P}-py3.11.patch
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter-server[${PYTHON_USEDEP}]
	dev-python/jupyter_server_mathjax[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source \
	dev-python/recommonmark \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}"/${P}-jupyter_server2.patch
	"${DISTDIR}"/${P}-py3.11.patch
)

EPYTEST_DESELECT=(
	nbdime/tests/test_decision_tools.py::test_build_diffs_unsorted
	nbdime/tests/test_diff_json_conversion.py::test_diff_to_json_patch
	nbdime/tests/test_merge_notebooks.py::test_merge_conflicts_get_diff_indices_shifted
	nbdime/tests/test_merge_notebooks.py::test_merge_inserts_within_deleted_range
	nbdime/tests/test_merge_notebooks.py::test_merge_interleave_cell_add_remove
	nbdime/tests/test_merge_notebooks.py::test_merge_multiline_cell_source_conflict
	nbdime/tests/test_merge.py::test_deep_merge_lists_delete_no_conflict__currently_expected_failures
	nbdime/tests/test_server_extension.py::test_diff_api_checkpoint
	nbdime/tests/test_web.py::test_api_diff
	nbdime/tests/test_web.py::test_api_merge
	nbdime/tests/test_web.py::test_fetch_diff
	nbdime/tests/test_web.py::test_fetch_merge
	nbdime/tests/test_web.py::test_offline_mathjax
)

src_prepare() {
	edos2unix \
		setupbase.py \
		nbdime/tests/conftest.py \
		nbdime/tests/test_cli_apps.py \
		nbdime/tests/test_web.py \
		nbdime/webapp/nbdimeserver.py

	distutils-r1_src_prepare
}

python_configure_all() {
	DISTUTILS_ARGS=( --skip-npm )
}

src_test() {
	# user.email and user.name are not configured in the sandbox
	git config --global user.email "larry@gentoo.org" || die
	git config --global user.name "Larry the Cow" || die

	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install
	mv "${ED}"{/usr,}/etc || die
}
