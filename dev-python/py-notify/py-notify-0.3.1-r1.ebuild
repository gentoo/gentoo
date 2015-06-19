# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/py-notify/py-notify-0.3.1-r1.ebuild,v 1.3 2015/01/26 10:28:49 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tools for implementing the Observer programming pattern in Python"
HOMEPAGE="http://home.gna.org/py-notify"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

python_test() {
	"${PYTHON}" run-tests.py || die "Tests failed"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
