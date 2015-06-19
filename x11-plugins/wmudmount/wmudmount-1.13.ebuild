# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmudmount/wmudmount-1.13.ebuild,v 1.1 2012/07/06 12:48:40 ssuominen Exp $

EAPI=4
inherit eutils gnome2-utils

DESCRIPTION="A filesystem mounter that uses udisks to handle notification and mounting"
HOMEPAGE="http://sourceforge.net/projects/wmudmount/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring libnotify"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.20
	>=x11-libs/gtk+-2.18:2
	x11-libs/libX11
	gnome-keyring? ( gnome-base/libgnome-keyring )
	libnotify? ( >=x11-libs/libnotify-0.7 )"
RDEPEND="${COMMON_DEPEND}
	sys-fs/udisks:0"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"

DOCS="ChangeLog"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-headers.patch
}

src_configure() {
	econf \
		$(use_with libnotify) \
		$(use_with gnome-keyring)
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
