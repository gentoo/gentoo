# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/latexila/latexila-3.14.4.ebuild,v 1.1 2015/03/28 09:54:20 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
VALA_MIN_API_VERSION="0.26"

inherit gnome2 vala

DESCRIPTION="Integrated LaTeX environment for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/LaTeXila"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latexmk rubber"

COMMON_DEPEND="
	app-text/enchant
	>=app-text/gtkspell-3.0.4:3
	>=dev-libs/glib-2.40:2[dbus]
	>=dev-libs/libgee-0.10:0.8=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.14:3
	>=x11-libs/gtksourceview-3.14.3:3.0
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
	x11-libs/pango
	$(vala_depend)
"
RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	x11-themes/hicolor-icon-theme
	latexmk? ( dev-tex/latexmk )
	rubber? ( dev-tex/rubber )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	virtual/pkgconfig
"

src_prepare() {
	DOCS="AUTHORS HACKING NEWS README"
	gnome2_src_prepare
	vala_src_prepare
}
