# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An understated pager for Blackbox"
HOMEPAGE="http://bbtools.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="x11-wm/blackbox"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS BUGS ChangeLog README TODO data/README.bbpager )
PATCHES=(
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-as-needed.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	rm "${ED}"/usr/share/bbtools/README.bbpager || die
}
