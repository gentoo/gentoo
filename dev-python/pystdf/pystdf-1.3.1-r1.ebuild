# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pystdf/pystdf-1.3.1-r1.ebuild,v 1.1 2015/01/05 04:24:24 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module that makes it easy to work with STDF"
HOMEPAGE="http://code.google.com/p/pystdf/"
SRC_URI="http://pystdf.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
