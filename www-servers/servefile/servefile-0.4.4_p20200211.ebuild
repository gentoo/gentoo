# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_COMMIT=864b2161b16e432c8ba19db1914809e080d793af
DESCRIPTION="Serve a single file via HTTP"
HOMEPAGE="https://github.com/sebageek/servefile"
SRC_URI="https://github.com/sebageek/servefile/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl test"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	sys-apps/grep
	sys-apps/iproute2
	sys-apps/net-tools
	sys-apps/sed"
DEPEND="test? (
		${RDEPEND}
		dev-python/requests[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${PN}-${MY_COMMIT}

PATCHES=(
	"${FILESDIR}"/${P}-ipv6-absent-tests.patch
)

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	doman ${PN}.1
}
