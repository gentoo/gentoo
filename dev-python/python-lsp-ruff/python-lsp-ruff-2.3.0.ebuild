# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Ruff linting plugin for the Python LSP Server"
HOMEPAGE="
	https://github.com/python-lsp/python-lsp-ruff/
	https://pypi.org/project/python-lsp-ruff/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-util/ruff-0.2.0
	dev-python/cattrs[${PYTHON_USEDEP}]
	dev-python/python-lsp-server[${PYTHON_USEDEP}]
	>=dev-python/lsprotocol-2023.0.1[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	# Fails due to Gentoofied calling of ruff
	"tests/test_ruff_lint.py::test_ruff_config_param"
	"tests/test_ruff_lint.py::test_ruff_settings"
)

distutils_enable_tests pytest
