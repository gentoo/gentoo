# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Simple Smartcard Interpreter"
HOMEPAGE="https://github.com/Eric-Bourry/pssi"
SRC_URI="https://pssi.googlecode.com/files/${P}.tar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pyscard[${PYTHON_USEDEP}]"
