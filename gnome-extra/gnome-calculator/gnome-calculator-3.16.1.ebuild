# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-calculator/gnome-calculator-3.16.1.ebuild,v 1.1 2015/06/09 16:07:00 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Calculator"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libxml2:2
	dev-libs/mpfr:0
	>=x11-libs/gtk+-3.11.6:3
	>=x11-libs/gtksourceview-3.15.1:3.0
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-utils-2.3
	!gnome-extra/gcalctool
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		ITSTOOL=$(type -P true) \
		VALAC=$(type -P true)
}
