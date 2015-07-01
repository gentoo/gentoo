# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmpris2client/libmpris2client-0.1.0.ebuild,v 1.3 2015/07/01 17:00:04 zlogene Exp $

EAPI=5
inherit eutils gnome2-utils

DESCRIPTION="An library to control MPRIS2 compatible players"
HOMEPAGE="http://github.com/matiasdelellis/libmpris2client"
SRC_URI="http://github.com/matiasdelellis/${PN}/releases/download/V${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS NEWS README TODO"

src_install() {
	default
	prune_libtool_files
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
