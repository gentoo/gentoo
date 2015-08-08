# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="This library provides a pure python interface for the Twitter API"
HOMEPAGE="http://code.google.com/p/python-twitter/"
SRC_URI="http://python-twitter.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="examples"

RDEPEND="dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# Testsuite in the source is not convincing in its completeness
RESTRICT="test"

src_prepare() {
	distutils-r1_src_prepare
	# Delete internal copy of simplejson.
	rm -fr simplejson || die
}

# http://code.google.com/p/python-twitter/issues/detail?id=259&thanks=259&ts=1400334214
python_test() {
	esetup.py test
}
