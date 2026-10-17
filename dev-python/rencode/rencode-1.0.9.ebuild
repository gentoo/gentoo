# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/aresch/rencode
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Serialization similar to bencode from the BitTorrent project"
HOMEPAGE="
	https://github.com/aresch/rencode/
	https://pypi.org/project/rencode/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~sparc ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	rm -rf rencode || die
	epytest
}
