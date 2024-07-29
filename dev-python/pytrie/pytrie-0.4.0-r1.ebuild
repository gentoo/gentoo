# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="PyTrie"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A pure Python implementation of the trie data structure"
HOMEPAGE="
	https://github.com/gsakkis/pytrie/
	https://pypi.org/project/PyTrie/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
