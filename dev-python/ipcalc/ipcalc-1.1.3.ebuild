# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipcalc/ipcalc-1.1.3.ebuild,v 1.3 2015/03/08 23:50:57 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="IP subnet calculator"
HOMEPAGE="http://pypi.python.org/pypi/ipcalc/"
SRC_URI="mirror://pypi/i/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE=""
