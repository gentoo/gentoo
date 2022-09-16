# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="similar to bencode from the BitTorrent project"
HOMEPAGE="https://github.com/aresch/rencode"
SRC_URI="https://github.com/aresch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/aresch/rencode/commit/16e61e1ff4294bddb7c881536d3d454355c78969
	"${FILESDIR}/${P}-drop-wheel-dependency.patch"
	# bug #812437
	"${FILESDIR}/${P}-fix-CVE-2021-40839.patch"
)

python_test() {
	# The C extension ("_rencode") can't be imported from "${S}/rencode"
	# so we need to cd somewhere else to make sure "rencode" is imported
	# from ${BUILD_DIR}/lib (thanks to PYTHONPATH).
	cd "${T}" || die
	epytest "${S}"
}
