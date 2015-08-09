# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Interface to OpenMarket's FastCGI C Library/SDK"
HOMEPAGE="http://pypi.python.org/pypi/python-fastcgi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=dev-libs/fcgi-2.4.0-r2"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

CFLAGS="${CFLAGS} -fno-strict-aliasing"

PATCHES=( "${FILESDIR}/${P}-setup.patch" )

python_install_all() {
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
