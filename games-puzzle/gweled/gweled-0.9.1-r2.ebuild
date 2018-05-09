# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="Bejeweled clone game"
HOMEPAGE="http://www.gweled.org/"
SRC_URI="https://launchpad.net/gweled/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	media-libs/libmikmod
	gnome-base/librsvg:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gentoo.patch
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	filter-flags -fomit-frame-pointer
	append-ldflags -Wl,--export-dynamic

	econf --disable-setgid
}
