# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A lightweight and fast raw image thumbnailer"
HOMEPAGE="https://github.com/erlendd/raw-thumbnailer"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/libopenraw-0.1:=[gtk]
	x11-libs/gtk+:2
	!media-gfx/gnome-raw-thumbnailer"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog )
PATCHES=(
	"${FILESDIR}"/${P}-libopenraw.patch  # bug 609972
)

src_prepare() {
	default
	eautoreconf
}
