# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy)

inherit eutils distutils-r1

DESCRIPTION="An implementation of JSON Reference for Python"
HOMEPAGE="https://github.com/gazpachoking/jsonref https://pypi.python.org/pypi/jsonref"
SRC_URI="https://github.com/gazpachoking/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
