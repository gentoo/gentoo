# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="A python module for interacting with Bugzilla over XMLRPC"
HOMEPAGE="https://github.com/python-bugzilla/python-bugzilla"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	|| ( dev-python/python-magic[${PYTHON_USEDEP}] sys-apps/file[python,${PYTHON_USEDEP}] )
	dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
