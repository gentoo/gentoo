# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Graphical implementation of the sliding puzzle game fifteen"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# allow using newer gtk+:3 (bug #536994)
	sed -i 's/-DGTK_DISABLE_DEPRECATED=1 //' Makefile.in || die
}

src_configure() {
	econf --disable-assembly
}

src_install() {
	default

	doicon ${PN}.svg
	domenu gfifteen.desktop
}
