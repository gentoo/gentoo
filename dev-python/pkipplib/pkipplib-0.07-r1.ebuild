# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pkipplib/pkipplib-0.07-r1.ebuild,v 1.1 2014/12/25 23:41:48 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Pkipplib is a Python module which parses IPP requests"
HOMEPAGE="http://www.pykota.com/software/pkipplib/"
SRC_URI="http://www.pykota.com/software/pkipplib/download/tarballs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
