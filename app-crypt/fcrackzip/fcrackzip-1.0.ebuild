# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="a zip password cracker"
HOMEPAGE="http://oldhome.schmorp.de/marc/fcrackzip.html"
SRC_URI="http://oldhome.schmorp.de/marc/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/unzip"
DEPEND=""

src_prepare() {
	default
	sed -i -e '/funroll/d' configure || die
}

src_install() {
	default
	mv "${ED}"/usr/bin/{zipinfo,fcrack-zipinfo} || die
}
