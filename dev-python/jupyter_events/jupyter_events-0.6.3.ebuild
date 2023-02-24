# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Jupyter Event System library"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/jupyter_events/
	https://pypi.org/project/jupyter-events/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"

# jsonschema[format-nongpl] deps are always on in our ebuild
RDEPEND="
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-json-logger-2.0.4[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
	)
"

# TODO: package jupyterlite-sphinx
# distutils_enable_sphinx docs
distutils_enable_tests pytest
