# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517="poetry"

inherit distutils-r1

DESCRIPTION="Pygments lexer and style Ansible snippets"
HOMEPAGE="https://github.com/ansible-community/ansible-pygments"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

# 2.11.0+ needed in order for tests to pass
RDEPEND=">=dev-python/pygments-2.11.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
