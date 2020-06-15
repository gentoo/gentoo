# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Python 3 library for XMPP"
HOMEPAGE="https://dev.louiz.org/projects/slixmpp"
LICENSE="MIT"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://lab.louiz.org/poezio/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DEPEND="
	net-dns/libidn
"
RDEPEND="
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	${DEPEND}
"

distutils_enable_tests pytest
