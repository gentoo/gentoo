# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An understated pager for Blackbox"
HOMEPAGE="http://bbtools.sourceforge.net/"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-wm/blackbox"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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
	rm "${ED%/}"/usr/share/bbtools/README.bbpager || die
}
