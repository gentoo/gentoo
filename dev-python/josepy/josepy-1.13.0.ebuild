# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="JOSE protocol implementation in Python"
HOMEPAGE="
	https://github.com/certbot/josepy/
	https://pypi.org/project/josepy/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/cryptography-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# Remove coverage/flake8 options
	sed -e '/^addopts =/d' -e '/^flake8-ignore/d' -i pytest.ini || die
	distutils-r1_src_prepare
}
