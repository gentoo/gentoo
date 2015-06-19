# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/Flask-KVSession/Flask-KVSession-0.6.2.ebuild,v 1.1 2015/06/08 07:46:10 aballier Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Transparent server-side session support for flask"
HOMEPAGE="https://pypi.python.org/pypi/Flask-KVSession https://github.com/mbr/flask-kvsession"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/simplekv-0.9.1[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.20[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
