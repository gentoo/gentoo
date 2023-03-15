# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="
	https://github.com/Calysto/metakernel/
	https://pypi.org/project/metakernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/ipykernel-5.5.6[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.9.2[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.18[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/jupyter_kernel_test[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile
	metakernel/tests/test_parser.py::test_path_completions
	# requires starting ipycluster
	metakernel/magics/tests/test_parallel_magic.py::test_parallel_magic
)
