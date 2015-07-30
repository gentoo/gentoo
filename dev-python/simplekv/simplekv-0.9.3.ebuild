# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/simplekv/simplekv-0.9.3.ebuild,v 1.1 2015/07/30 07:40:38 patrick Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A key-value storage for binary data, support many backends."
HOMEPAGE="https://pypi.python.org/pypi/simplekv/ https://github.com/mbr/simplekv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""
