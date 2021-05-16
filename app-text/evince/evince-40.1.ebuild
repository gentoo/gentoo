# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson systemd xdg

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Evince"

LICENSE="GPL-2+ CC-BY-SA-3.0"
# subslot = evd3.(suffix of libevdocument3)-evv3.(suffix of libevview3)
SLOT="0/evd3.4-evv3.3"
IUSE="cups djvu dvi gstreamer gnome gnome-keyring gtk-doc +introspection nautilus nsplugin postscript spell t1lib tiff xps"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"

# atk used in libview
# bundles unarr
DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.44.0:2
	>=gui-libs/libhandy-1.0:1=
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	>=x11-libs/gdk-pixbuf-2.40:2
	>=x11-libs/gtk+-3.22.0:3[cups?,introspection?]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10:=
	>=app-text/poppler-0.76.0[cairo]
	>=app-arch/libarchive-3.2.0
	djvu? ( >=app-text/djvu-3.5.22:= )
	dvi? (
		>=app-text/libspectre-0.2:=
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= ) )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0 )
	gnome? ( gnome-base/gnome-desktop:3= )
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-1:= )
	nautilus? ( >=gnome-base/nautilus-3.28.0 )
	postscript? ( >=app-text/libspectre-0.2:= )
	spell? ( >=app-text/gspell-1.6.0:= )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
	|| (
		>=x11-themes/adwaita-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10
	)
"
BDEPEND="
	gtk-doc? ( >=dev-util/gtk-doc-1.33 )
	app-text/docbook-xml-dtd:4.3
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/40.0-internal-synctex.patch
)

src_prepare() {
	default

	# Do not depend on adwaita-icon-theme, bug #326855, #391859
	# https://gitlab.freedesktop.org/xdg/default-icon-theme/issues/7
	sed -i '/adwaita_icon_theme_dep/d' meson.build shell/meson.build || die

	# https://gitlab.gnome.org/GNOME/evince/-/merge_requests/336
	sed -i -e 's:T1_initLib:T1_InitLib:' meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dplatform=gnome

		-Dviewer=true
		-Dpreviewer=false
		-Dthumbnailer=true
		$(meson_use nsplugin browser_plugin)
		$(meson_use nautilus)

		-Dcomics=enabled
		$(meson_feature djvu)
		$(meson_feature dvi)
		-Dpdf=enabled
		$(meson_feature postscript ps)
		$(meson_feature tiff)
		$(meson_feature xps)

		$(meson_use gtk-doc gtk_doc)
		-Duser_doc=true
		$(meson_use introspection)
		-Ddbus=true
		$(meson_feature gnome-keyring keyring)
		$(meson_feature cups gtk_unix_print)
		$(meson_feature gnome thumbnail_cache)
		$(meson_feature gstreamer multimedia)
		$(meson_feature spell gspell)

		$(meson_feature t1lib)

		-Dbrowser_plugin_dir="${EPREFIX}/usr/$(get_libdir)/nsbrowser/plugins"
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"

	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install
}
