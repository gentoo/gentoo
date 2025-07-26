# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pygments lexer and style Ansible snippets"
HOMEPAGE="
	https://github.com/ansible-community/ansible-pygments/
	https://pypi.org/project/ansible-pygments/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/pygments-2.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pygments-2.11.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
