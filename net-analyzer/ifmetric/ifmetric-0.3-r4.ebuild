# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Set metrics of all IPv4 routes attached to a given network interface at once"
HOMEPAGE="http://0pointer.de/lennart/projects/ifmetric/"
SRC_URI="http://0pointer.de/lennart/projects/ifmetric/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="sys-kernel/linux-headers"

PATCHES=(
	"${FILESDIR}"/${P}-ul.patch
	"${FILESDIR}"/${P}-replybuf.patch
)
HTML_DOCS=( doc/README.html )

src_prepare() {
	default

	# bug #899926
	eautoreconf
}

src_configure() {
	# man page and HTML are already generated
	econf \
		--disable-xmltoman \
		--disable-lynx
}
