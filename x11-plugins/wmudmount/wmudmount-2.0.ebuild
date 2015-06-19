# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmudmount/wmudmount-2.0.ebuild,v 1.1 2014/02/09 23:51:51 voyageur Exp $

EAPI=5
inherit eutils gnome2-utils

DESCRIPTION="A filesystem mounter that uses udisks to handle notification and mounting"
HOMEPAGE="http://sourceforge.net/projects/wmudmount/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring libnotify"

RDEPEND="sys-fs/udisks:2
	>=x11-libs/gtk+-3.8.0:3
	gnome-keyring? ( gnome-base/libgnome-keyring )
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"

DOCS="ChangeLog"

src_configure() {
	econf \
		$(use_with libnotify) \
		$(use_with gnome-keyring)
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
