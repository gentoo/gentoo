# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 pypy )

inherit distutils-r1

MY_P="${P/_p/.post}"

DESCRIPTION="Library for OAuth version 1.0"
HOMEPAGE="https://pypi.python.org/pypi/oauth2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

RDEPEND="dev-python/httplib2[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${PV}-exclude-tests.patch" )
S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test
}
