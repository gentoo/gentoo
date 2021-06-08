# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Core common functionality of Jupyter projects"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="dev-python/traitlets[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		>=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs \
	dev-python/sphinxcontrib-github-alt
distutils_enable_tests pytest

python_test() {
	local deselect=(
		# fails if jupyter is not in system sitedir
		# (PYTHONPATH is insufficient)
		jupyter_core/tests/test_command.py::test_not_on_path
		jupyter_core/tests/test_command.py::test_path_priority
		# TODO
		jupyter_core/tests/test_paths.py::test_jupyter_path_prefer_env
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests failed with ${EPYTHON}"
}
