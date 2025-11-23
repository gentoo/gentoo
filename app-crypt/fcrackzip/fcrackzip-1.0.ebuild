# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Zip password cracker"
HOMEPAGE="http://oldhome.schmorp.de/marc/fcrackzip.html"
SRC_URI="http://oldhome.schmorp.de/marc/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-Fix-Wimplicit-int.patch
)

src_prepare() {
	default
	sed -i -e '/funroll/d' configure || die
}

src_install() {
	default
	mv "${ED}"/usr/bin/{zipinfo,fcrack-zipinfo} || die
}
