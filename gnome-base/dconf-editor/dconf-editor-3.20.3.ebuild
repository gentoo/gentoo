# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~arm-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.46.0:2
	>=gnome-base/dconf-0.23.2
	>=x11-libs/gtk+-3.19.5:3
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/dconf-0.22[X]
"
