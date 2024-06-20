# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

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
	dev-python/pygments[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.1-make_lexer_test_compare_tokens.patch
)

distutils_enable_tests pytest
