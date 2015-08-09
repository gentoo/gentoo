# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnome2-utils

DESCRIPTION="A filesystem mounter that uses udisks to handle notification and mounting"
HOMEPAGE="http://sourceforge.net/projects/wmudmount/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-keyring libnotify"

RDEPEND=">=x11-libs/gtk+-2.18:2
	dev-libs/dbus-glib
	sys-fs/udisks:0
	gnome-keyring? ( gnome-base/libgnome-keyring )
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"

src_configure() {
	econf \
		$(use_with libnotify) \
		$(use_with gnome-keyring)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog
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
