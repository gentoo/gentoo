# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A client library for executing Jupyter notebooks"
HOMEPAGE="
	https://nbclient.readthedocs.io/en/latest/
	https://github.com/jupyter/nbclient/
	https://pypi.org/project/nbclient/
"
SRC_URI="
	https://github.com/jupyter/nbclient/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/jupyter_client-6.1.5[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.0[${PYTHON_USEDEP}]
	dev-python/nest_asyncio[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.2.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		dev-python/xmltodict[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	nbclient/tests/test_client.py::test_many_parallel_notebooks
	'nbclient/tests/test_client.py::test_run_all_notebooks[Interrupt.ipynb-opts6]'
)
