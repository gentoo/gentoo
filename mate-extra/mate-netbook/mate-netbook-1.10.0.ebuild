# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="no"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE utilities for netbooks"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND=">=mate-base/mate-desktop-1.10.0:0
	>=mate-base/mate-panel-1.10.0:0
	>=dev-libs/glib-2.36:2
	dev-libs/libunique:1
	x11-libs/gtk+:2
	x11-libs/libwnck:1
	x11-libs/libfakekey:0
	x11-libs/libXtst:0
	x11-libs/libX11:0
	x11-libs/cairo:0
	virtual/libintl:0"

DEPEND="${RDEPEND}
	x11-proto/xproto:0
	>=dev-util/intltool-0.34:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	gnome2_src_configure --with-gtk=2.0
}

DOCS="AUTHORS ChangeLog NEWS README"
