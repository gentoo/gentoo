# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Requests-compatible interface for PycURL"
HOMEPAGE="https://github.com/dcoles/pycurl-requests"
SRC_URI="https://github.com/dcoles/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/pycurl-requests-0.2.0-test.patch"
)

distutils_enable_tests pytest
