# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 pypy{,3} python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Functions for server CLI applications used by humans"
HOMEPAGE="https://github.com/joeyespo/path-and-address"
LICENSE="MIT"

SLOT="0"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

KEYWORDS="~amd64"
