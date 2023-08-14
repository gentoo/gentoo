# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="A hatch plugin to help build Jupyter packages"
HOMEPAGE="
	https://pypi.org/project/hatch-jupyter-builder/
	https://github.com/jupyterlab/hatch-jupyter-builder
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/hatchling[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Calls pip, requires internet
	tests/test_plugin.py::test_hatch_build
)

distutils_enable_tests pytest
