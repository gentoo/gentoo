# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_LIBTOOL=none
inherit autotools eutils gnome2-utils

DESCRIPTION="Volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
SRC_URI="https://github.com/nicklan/pnmixer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_with libnotify) \
		$(use_enable debug) \
		--enable-minimal-flags \
		--with-gtk3
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
