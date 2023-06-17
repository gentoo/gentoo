# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517="poetry"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Pygments lexer and style Ansible snippets"
HOMEPAGE="https://github.com/ansible-community/ansible-pygments"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

# 2.14.0+ needed in order for tests to pass
RDEPEND=">=dev-python/pygments-2.14.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.1-tests_pygments2_14.patch
)

distutils_enable_tests pytest
