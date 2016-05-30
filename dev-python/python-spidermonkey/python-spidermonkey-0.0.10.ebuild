# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7)
inherit distutils-r1

DESCRIPTION="JavaScript / Python bridge"
HOMEPAGE="https://github.com/davisp/python-spidermonkey"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
		dev-libs/nspr
		>=dev-python/nose-0.10.0[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}"

PATCHES=("${FILESDIR}"/${P}-tests.patch)

python_test() {
	esetup.py test
}
