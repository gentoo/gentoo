# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="no"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE indicator applet"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

IUSE=""

RDEPEND=">=x11-libs/gtk+-2.24:2"

DEPEND="${RDEPEND}
	>=dev-libs/libindicator-0.3.90:0
	>=dev-util/intltool-0.35.0
	>=mate-base/mate-panel-1.10:0
	virtual/pkgconfig"
