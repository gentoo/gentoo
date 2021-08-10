# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Adds PKCS#12 support to the Python requests library in a clean way"
HOMEPAGE="https://github.com/m-click/requests_pkcs12"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=""

RDEPEND="
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

RESTRICT="test" # no tests
