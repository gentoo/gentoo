# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Search tool for GNOME 3"
HOMEPAGE="https://wiki.gnome.org/Apps/Attic/GnomeUtils"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.30:2
	sys-apps/grep
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3:3[X]
	x11-libs/libICE
	x11-libs/libSM
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/findutils
	|| ( sys-apps/mlocate sys-freebsd/freebsd-ubin )
	!<gnome-extra/gnome-utils-3.4
"
# ${PN} was part of gnome-utils before 3.4
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_configure() {
	G2CONF="${G2CONF} ITSTOOL=$(type -P true)"
	gnome2_src_configure
}
