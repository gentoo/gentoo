# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Serialization similar to bencode from the BitTorrent project"
HOMEPAGE="
	https://github.com/aresch/rencode/
	https://pypi.org/project/rencode/
"
SRC_URI="
	https://github.com/aresch/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	rm -rf rencode || die
	epytest
}
