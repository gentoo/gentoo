# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=python-spake2-${PV}
DESCRIPTION="python implementation of SPAKE2 password-authenticated key exchange algorithm"
HOMEPAGE="
	https://github.com/warner/python-spake2/
	https://pypi.org/project/spake2/
"
SRC_URI="
	https://github.com/warner/python-spake2/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-do_not_use_hkdf_package.patch
)

distutils_enable_tests pytest

src_prepare() {
	# remove outdated bundled versioneer
	rm versioneer.py || die
	distutils-r1_src_prepare
}
