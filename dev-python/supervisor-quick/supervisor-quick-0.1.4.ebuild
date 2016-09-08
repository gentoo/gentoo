# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Bypass supervisor's nasty callbacks stack and make it quick!"
HOMEPAGE="https://pypi.python.org/pypi/supervisor-quick/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-admin/supervisor[${PYTHON_USEDEP}]
"
