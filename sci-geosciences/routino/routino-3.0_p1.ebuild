# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

DESCRIPTION="Routing application based on openstreetmap data"
HOMEPAGE="http://www.routino.org/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tgz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="!<sci-geosciences/qmapshack-1.5"
PATCHES=( "${FILESDIR}"/makefile-conf.patch )

src_configure() {
	:
}

src_compile() {
	emake -j1
	rm README.txt
	mv doc/rm README.txt .
}
