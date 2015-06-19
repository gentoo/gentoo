# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pssi/pssi-1.0-r1.ebuild,v 1.1 2015/02/17 00:44:56 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Simple Smartcard Interpreter"
HOMEPAGE="http://code.google.com/p/pssi/"
SRC_URI="http://pssi.googlecode.com/files/${P}.tar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pyscard[${PYTHON_USEDEP}]"
