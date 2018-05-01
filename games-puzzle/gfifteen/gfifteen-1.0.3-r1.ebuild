# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

DESCRIPTION="Graphical implementation of the sliding puzzle game fifteen"
HOMEPAGE="https://frigidcode.com/code/gfifteen/"
SRC_URI="https://frigidcode.com/code/gfifteen/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	# make it compile against newer gtk+:3 (bug #536994)
	sed -i \
		-e 's/-DGTK_DISABLE_DEPRECATED=1 //' \
		Makefile.in || die
}

src_configure() {
	econf --disable-assembly
}

src_install() {
	default
	doicon -s scalable ${PN}.svg
	domenu gfifteen.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
