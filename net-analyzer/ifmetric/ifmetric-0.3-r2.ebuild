# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Set metrics of all IPv4 routes attached to a given network interface at once"
HOMEPAGE="http://0pointer.de/lennart/projects/ifmetric/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="sys-kernel/linux-headers"

DOCS=(
	README
	doc/README.html
)

PATCHES=(
	"${FILESDIR}"/${P}-ul.patch
	"${FILESDIR}"/${P}-replybuf.patch
)

src_configure() {
	# man page and HTML are already generated
	econf \
		--disable-xmltoman \
		--disable-lynx
}
