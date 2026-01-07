# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Serve a single file via HTTP"
HOMEPAGE="https://github.com/sebageek/servefile"
SRC_URI="https://github.com/sebageek/servefile/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl test"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	sys-apps/grep
	sys-apps/iproute2
	sys-apps/net-tools
	sys-apps/sed
	$(python_gen_cond_dep '
		dev-python/legacy-cgi[${PYTHON_USEDEP}]
	' 3.13 3.14)"
DEPEND="test? (
		${RDEPEND}
		dev-python/requests[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.2-ipv6-absent-tests.patch
)

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	doman ${PN}.1
}
