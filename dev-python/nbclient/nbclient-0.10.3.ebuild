# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A client library for executing Jupyter notebooks"
HOMEPAGE="
	https://nbclient.readthedocs.io/en/latest/
	https://github.com/jupyter/nbclient/
	https://pypi.org/project/nbclient/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/jupyter-client-6.1.12[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.1.3[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		>=dev-python/ipykernel-6.19.3[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		>=dev-python/nbconvert-7.1.0[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		dev-python/xmltodict[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( flaky pytest-asyncio )
EPYTEST_RERUNS=3
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# hangs?
	'tests/test_client.py::test_run_all_notebooks[Interrupt.ipynb-opts6]'
)
