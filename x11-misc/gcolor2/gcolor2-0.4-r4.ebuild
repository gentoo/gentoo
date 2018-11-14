# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="A GTK+ color selector"
HOMEPAGE="http://gcolor2.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~pacho/gnome/${PN}.svg"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.27
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/modular-rgb.patch
	epatch "${FILESDIR}"/${P}-amd64.patch
	epatch "${FILESDIR}"/${P}-pkg-config-macro.patch

	# To check at each bump.
	sed "s/^#.*/[encoding: UTF-8]/" -i po/POTFILES.in || die "sed failed"
	echo "gcolor2.glade" >> po/POTFILES.in

	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	# Icon from https://sourceforge.net/p/gcolor2/patches/5/
	doicon -s scalable "${DISTDIR}/${PN}.svg"
	make_desktop_entry ${PN} Gcolor2 ${PN} Graphics
}
