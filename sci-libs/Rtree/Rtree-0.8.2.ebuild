# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/Rtree/Rtree-0.8.2.ebuild,v 1.1 2015/02/20 11:19:37 slis Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="R-Tree spatial index for Python GIS"
HOMEPAGE="https://pypi.python.org/pypi/Rtree"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/libspatialindex
	sci-libs/scipy"
DEPEND="dev-python/setuptools"
