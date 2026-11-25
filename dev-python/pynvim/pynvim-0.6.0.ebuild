# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Python client for Neovim"
HOMEPAGE="
	https://github.com/neovim/pynvim/
	https://pypi.org/project/pynvim/
"
SRC_URI="
	https://github.com/neovim/pynvim/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"

RDEPEND="
	>=dev-python/greenlet-3.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		app-editors/neovim
	)
"

EPYTEST_PLUGINS=()
: ${EPYTEST_TIMEOUT:=5}
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# changed error message
	test/test_vim.py::test_command_error
)
