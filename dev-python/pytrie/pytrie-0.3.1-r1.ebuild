# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN="PyTrie"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="A pure Python implementation of the trie data structure"
HOMEPAGE="https://github.com/gsakkis/pytrie/ https://pypi.org/project/PyTrie/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/sortedcontainers[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
