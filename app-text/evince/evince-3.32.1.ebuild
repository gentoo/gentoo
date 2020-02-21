# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2 systemd

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Evince"

LICENSE="GPL-2+ CC-BY-SA-3.0"
# subslot = evd3.(suffix of libevdocument3)-evv3.(suffix of libevview3)
SLOT="0/evd3.4-evv3.3"
IUSE="djvu dvi gstreamer gnome gnome-keyring +introspection nautilus nsplugin postscript spell t1lib tiff xps"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"

# atk used in libview
# bundles unarr
COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.36:2[dbus]
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	>=x11-libs/gdk-pixbuf-2.36.5:2
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10:=
	>=app-text/poppler-0.76.0[cairo]
	>=app-arch/libarchive-3.2.0
	djvu? ( >=app-text/djvu-3.5.22:= )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= ) )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0 )
	gnome? ( gnome-base/gnome-desktop:3= )
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-1:= )
	nautilus? ( >=gnome-base/nautilus-2.91.4 )
	postscript? ( >=app-text/libspectre-0.2:= )
	spell? ( >=app-text/gspell-1.6.0:= )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
	|| (
		>=x11-themes/adwaita-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10 )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	app-text/yelp-tools
"
# eautoreconf needs:
#  app-text/yelp-tools

PATCHES=(
	"${FILESDIR}"/3.30.2-internal-synctex.patch # don't automagically link to synctex from texlive-core - always use internal copy of this small parser for now; requires eautoreconf
)

src_prepare() {
	gnome2_src_prepare

	# Do not depend on adwaita-icon-theme, bug #326855, #391859
	# https://gitlab.freedesktop.org/xdg/default-icon-theme/issues/7
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
		$(use_enable gstreamer multimedia) \
		$(use_enable gnome libgnome-desktop) \
		$(use_with gnome-keyring keyring) \
		$(use_enable introspection) \
		$(use_enable nautilus) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable postscript ps) \
		$(use_with spell gspell) \
		$(use_enable t1lib) \
		$(use_enable tiff) \
		$(use_enable xps) \
		BROWSER_PLUGIN_DIR="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins \
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
}
