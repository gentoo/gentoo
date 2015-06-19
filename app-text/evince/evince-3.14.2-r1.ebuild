# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-3.14.2-r1.ebuild,v 1.2 2015/06/10 20:59:58 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Evince"

LICENSE="GPL-2+ CC-BY-SA-3.0"
# subslot = evd3.(suffix of libevdocument3)-evv3.(suffix of libevview3)
SLOT="0/evd3.4-evv3.3"
IUSE="djvu dvi gnome +introspection libsecret nautilus nsplugin +postscript t1lib tiff xps"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"

# Since 2.26.2, can handle poppler without cairo support. Make it optional ?
# not mature enough
# atk used in libview
# gdk-pixbuf used all over the place
# libX11 used for totem-screensaver
COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.36:2[dbus]
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.14:3[introspection?]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10:=
	>=app-text/poppler-0.24:=[cairo]
	djvu? ( >=app-text/djvu-3.5.17:= )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= ) )
	gnome? ( gnome-base/gnome-desktop:3 )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	libsecret? ( >=app-crypt/libsecret-0.5 )
	nautilus? ( >=gnome-base/nautilus-2.91.4[introspection?] )
	postscript? ( >=app-text/libspectre-0.2:= )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
	|| (
		>=x11-themes/adwaita-icon-theme-2.17.1
		>=x11-themes/gnome-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10 )
	x11-themes/gnome-icon-theme-symbolic
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#  app-text/yelp-tools

src_prepare() {
	gnome2_src_prepare

	# Do not depend on adwaita-icon-theme, bug #326855, #391859
	# https://bugs.freedesktop.org/show_bug.cgi?id=29942
	sed -e 's/adwaita-icon-theme >= $ADWAITA_ICON_THEME_REQUIRED//g' \
		-i configure || die "sed failed"
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-pdf \
		--enable-comics \
		--enable-thumbnailer \
		--with-platform=gnome \
		--enable-dbus \
		$(use_enable djvu) \
		$(use_enable dvi) \
		$(use_with libsecret keyring) \
		$(use_enable gnome libgnome-desktop) \
		$(use_enable introspection) \
		$(use_enable nautilus) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable postscript ps) \
		$(use_enable t1lib) \
		$(use_enable tiff) \
		$(use_enable xps) \
		BROWSER_PLUGIN_DIR="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins \
		ITSTOOL=$(type -P true)
}
