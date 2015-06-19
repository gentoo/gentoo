# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/iniparse/iniparse-0.4-r1.ebuild,v 1.6 2015/04/08 08:05:13 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="http://code.google.com/p/iniparse http://pypi.python.org/pypi/iniparse"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

python_test() {
	"${PYTHON}" runtests.py || die
}
