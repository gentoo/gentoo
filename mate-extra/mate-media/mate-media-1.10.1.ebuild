# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Multimedia related programs for the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=dev-libs/glib-2.36.0:2
	>=dev-libs/libunique-1:1
	dev-libs/libxml2:2
	>=mate-base/mate-panel-1.10:0
	>=mate-base/mate-desktop-1.10:0
	>=media-libs/libcanberra-0.13:0[gtk]
	>=media-libs/libmatemixer-1.10
	x11-libs/cairo:0
	>=x11-libs/gtk+-2.24:2
	x11-libs/pango:0
	virtual/libintl:0"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0:*
	sys-devel/gettext:*
	virtual/pkgconfig:*
	!!<mate-base/mate-applets-1.8:*"

src_configure() {
	gnome2_src_configure --with-gtk=2.0
}

DOCS="AUTHORS ChangeLog* NEWS README"
