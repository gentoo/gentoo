# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10,11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Finds file leaks and other security problems on HTTP servers"
HOMEPAGE="https://github.com/hannob/snallygaster"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/dnspython
	dev-python/urllib3
	dev-python/beautifulsoup4"
RDEPEND="${DEPEND}"
DOCS=( README.md TESTS.md )

# Only codingstyle and similar tests, require dependencies
# not packaged in Gentoo
RESTRICT="test"
