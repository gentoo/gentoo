# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="JanRain's URL Utilities"
HOMEPAGE="http://www.openidenabled.com/openid/libraries/python/"
SRC_URI="http://www.openidenabled.com/resources/downloads/python-openid/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl test"

RDEPEND="curl? ( >=dev-python/pycurl-7.15.1[${PYTHON_USEDEP}] )"
DEPEND=""

REQUIRED_USE="test? ( curl )"
# test fails if it finds 'localhost' instead of '127.0.0.1'
PATCHES=( "${FILESDIR}/${P}-gentoo-test_fetchers.patch" )

python_test() {
	PYTHONPATH=. "${PYTHON}" admin/runtests || die "tests failed"
}
