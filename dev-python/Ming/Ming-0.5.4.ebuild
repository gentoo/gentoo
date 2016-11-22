# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7)
inherit distutils-r1

DESCRIPTION="Database mapping layer for MongoDB on Python"
HOMEPAGE="http://merciless.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-0.8.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)"

RDEPEND=">=dev-python/formencode-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/pymongo-2.4[${PYTHON_USEDEP}]
	>=dev-python/pytz-1.6.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
