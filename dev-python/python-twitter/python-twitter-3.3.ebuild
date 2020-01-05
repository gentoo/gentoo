# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python wrapper around the Twitter API"
HOMEPAGE="https://github.com/bear/python-twitter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE="examples"

RDEPEND="
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# Testsuite is still not convincing in its completeness
RESTRICT="test"

src_prepare() {
	distutils-r1_src_prepare
}

# https://code.google.com/p/python-twitter/issues/detail?id=259&thanks=259&ts=1400334214
python_test() {
	esetup.py test
}
