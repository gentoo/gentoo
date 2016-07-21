# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1

DESCRIPTION="An enhanced gettext po file editor for GNOME"
HOMEPAGE="http://gtranslator.sourceforge.net/"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="gnome spell"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.4.2:3
	>=x11-libs/gtksourceview-3.0.0:3.0
	>=dev-libs/gdl-3.6:3=
	>=dev-libs/libxml2-2.4.12:2
	>=dev-libs/json-glib-0.12.0
	>=dev-libs/libpeas-1.2[gtk]
	gnome-extra/libgda:5=
	>=app-text/iso-codes-0.35

	gnome-base/gsettings-desktop-schemas

	gnome? (
		${PYTHON_DEPS}
		|| ( app-dicts/gnome-dictionary	=gnome-extra/gnome-utils-3.2* )
		x11-libs/gtk+:3[introspection] )
	spell? ( app-text/gtkspell:3= )"
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
	gnome? (
		>=dev-libs/libpeas-1.2[gtk,python,${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		gnome-extra/gucharmap:2.90[introspection] )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
# eautoreconf requires gnome-base/gnome-common, app-text/yelp-tools

pkg_setup() {
	use gnome && python-single-r1_pkg_setup
}

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING INSTALL NEWS README THANKS"
	G2CONF="${G2CONF}
		--disable-static
		$(use_with gnome dictionary)
		$(use_enable gnome introspection)
		$(use_with spell gtkspell3)
		ITSTOOL=$(type -P true)"

	gnome2_src_prepare

	if ! use gnome; then
		# don't install charmap plugin, it requires gnome-extra/gucharmap
		sed -e 's:\scharmap\s: :g' -i plugins/Makefile.* ||
			die "sed plugins/Makefile.* failed"
	fi
}
