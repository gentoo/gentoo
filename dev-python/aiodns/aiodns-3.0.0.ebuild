# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Simple DNS resolver for asyncio"
HOMEPAGE="https://github.com/saghul/aiodns/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE=""
# Tests fail with network-sandbox, since they try to resolve google.com
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND=">=dev-python/pycares-3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	# https://github.com/saghul/aiodns/commit/146286601fe80eb4ede8126769e79b5d5e63f64e
	"${FILESDIR}/${P}-py3.10-tests.patch"
)

python_test() {
	"${EPYTHON}" tests.py -v || die
}
