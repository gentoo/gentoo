# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pnmixer/pnmixer-9999.ebuild,v 1.1 2014/07/26 16:40:29 hasufell Exp $

EAPI=5

WANT_LIBTOOL=none
inherit autotools eutils gnome2-utils git-2

DESCRIPTION="Volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
EGIT_REPO_URI="git@github.com:nicklan/pnmixer.git
	https://github.com/nicklan/pnmixer.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
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
