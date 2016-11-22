# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

DESCRIPTION="Routing application based on openstreetmap data"
HOMEPAGE="http://www.routino.org/"
SRC_URI="http://www.routino.org/download/${P}.tgz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
PATCHES=( "${FILESDIR}"/${P}.patch )

src_configure() {
	:
}

src_compile() {
	emake -j1
	rm README.txt
	mv doc/rm README.txt .
}
