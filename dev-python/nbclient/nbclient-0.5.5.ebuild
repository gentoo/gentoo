# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A client library for executing Jupyter notebooks"
HOMEPAGE="
	https://nbclient.readthedocs.io/en/latest/
	https://github.com/jupyter/nbclient/
	https://pypi.org/project/nbclient/"
SRC_URI="
	https://github.com/jupyter/nbclient/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/jupyter_client-6.1.5[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.0[${PYTHON_USEDEP}]
	dev-python/nest_asyncio[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		dev-python/xmltodict[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
