# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Transit relay server for magic-wormhole"
HOMEPAGE="
	https://magic-wormhole.readthedocs.io/en/latest/
	https://github.com/magic-wormhole/magic-wormhole-transit-relay/
	https://pypi.org/project/magic-wormhole-transit-relay/
"
SRC_URI="
	https://github.com/magic-wormhole/magic-wormhole-transit-relay/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm versioneer.py || die
}
