# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517="poetry"
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Pygments lexer and style Ansible snippets"
HOMEPAGE="https://github.com/ansible-community/ansible-pygments"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.1-make_lexer_test_compare_tokens.patch
)

distutils_enable_tests pytest
