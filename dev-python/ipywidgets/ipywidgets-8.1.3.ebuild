# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="
	https://ipywidgets.readthedocs.io/
	https://github.com/jupyter-widgets/ipywidgets/
	https://pypi.org/project/ipywidgets/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-python/comm-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/ipython_genutils-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-4.0.11[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-widgets-3.0.11[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		<dev-python/pytest-8.1[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	>=dev-python/ipython-6.1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# https://github.com/pypy/pypy/issues/4892
				ipywidgets/widgets/tests/test_interaction.py::test_interact_noinspect
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
