# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_P=${P/-c}
DESCRIPTION="Python bindings for the BLAKE3 cryptographic hash function"
HOMEPAGE="https://github.com/oconnor663/blake3-py/"
SRC_URI="
	https://github.com/oconnor663/blake3-py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}/c_impl

LICENSE="|| ( CC0-1.0 Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!dev-python/blake3-py[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-backports.patch
)

python_test() {
	cd .. || die
	epytest
}
