# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Display NAT connections"
HOMEPAGE="http://tweegy.nl/projects/netstat-nat/index.html"
SRC_URI="http://tweegy.nl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}
