# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="https://code.google.com/p/iniparse https://pypi.python.org/pypi/iniparse"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

python_test() {
	"${PYTHON}" runtests.py || die
}
