# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oauth2/oauth2-1.5.211-r1.ebuild,v 1.5 2015/03/08 23:54:28 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Library for OAuth version 1.0"
HOMEPAGE="http://pypi.python.org/pypi/oauth2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="test"

RDEPEND="dev-python/httplib2[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${PN}-exclude-tests.patch" )

python_test() {
	esetup.py test || die "Tests fail with ${EPYTHON}"
}
