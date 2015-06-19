# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/compiz-plugins-main/compiz-plugins-main-0.8.8.ebuild,v 1.4 2012/10/09 19:28:28 pinkbyte Exp $

EAPI="4"

inherit autotools eutils gnome2-utils

DESCRIPTION="Compiz Fusion Window Decorator Plugins"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="gconf"

RDEPEND="
	>=gnome-base/librsvg-2.14.0:2
	x11-libs/cairo
	>=x11-libs/compiz-bcop-${PV}
	>=x11-wm/compiz-${PV}[gconf?]
	virtual/jpeg:0
	virtual/glu
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	>=sys-devel/gettext-0.15
	gconf? ( gnome-base/gconf:2 )
"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_prepare() {
	if ! use gconf; then
		epatch "${FILESDIR}"/${PN}-no-gconf.patch
		eautoreconf
	fi
}

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static \
		$(use_enable gconf schemas)
}

src_install() {
	default
	prune_libtool_files
}

pkg_preinst() {
	use gconf && gnome2_gconf_savelist
}

pkg_postinst() {
	use gconf && gnome2_gconf_install
}
