# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pnmixer/pnmixer-0.6_pre20140924.ebuild,v 1.1 2014/09/23 22:55:22 hasufell Exp $

EAPI=5

inherit eutils gnome2-utils

DESCRIPTION="Volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
SRC_URI="http://dev.gentoo.org/~hasufell/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug libnotify"

RDEPEND="dev-libs/glib:2
	media-libs/alsa-lib
	>=x11-libs/gtk+-3.6:3
	x11-libs/libX11
	libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_with libnotify) \
		$(use_enable debug) \
		--enable-minimal-flags \
		--with-gtk3
}

src_install() {
	default
	newicon -s 128 pixmaps/${PN}-about.png ${PN}.png
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
