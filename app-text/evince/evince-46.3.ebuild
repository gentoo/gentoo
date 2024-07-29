# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="https://apps.gnome.org/en/Evince/"

LICENSE="GPL-2+ CC-BY-SA-3.0"
# subslot = evd3.(suffix of libevdocument3)-evv3.(suffix of libevview3)
SLOT="0/evd3.4-evv3.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="cups djvu dvi gstreamer gnome keyring gtk-doc +introspection nautilus postscript spell tiff xps"
REQUIRED_USE="gtk-doc? ( introspection )"

# atk used in libview
# bundles unarr
DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.44.0:2
	>=gui-libs/libhandy-1.5.0:1
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	>=x11-libs/gdk-pixbuf-2.40:2
	>=x11-libs/gtk+-3.22.0:3[cups?,introspection?]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10
	>=app-text/poppler-22.05.0:=[cairo]
	>=app-arch/libarchive-3.6.0:=
	djvu? ( >=app-text/djvu-3.5.22:= )
	dvi? (
		>=app-text/libspectre-0.2:=
		dev-libs/kpathsea:=
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0 )
	gnome? ( gnome-base/gnome-desktop:3= )
	keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-1:= )
	nautilus? ( >=gnome-base/nautilus-3.28.0 <gnome-base/nautilus-42.20 )
	postscript? ( >=app-text/libspectre-0.2:= )
	spell? ( >=app-text/gspell-1.6.0:= )
	tiff? ( >=media-libs/tiff-4.0:= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
"
BDEPEND="
	gtk-doc? (
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.3
	)
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Ddevelopment=false
		-Dplatform=gnome

		-Dviewer=true
		-Dpreviewer=true
		-Dthumbnailer=true
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
		$(meson_feature keyring)
		$(meson_feature cups gtk_unix_print)
		$(meson_feature gnome thumbnail_cache)
		$(meson_feature gstreamer multimedia)
		$(meson_feature spell gspell)

		-Dinternal_synctex=true

		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use gtk-doc; then
	   mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
	   mv "${ED}"/usr/share/doc/{libevdocument,libevview} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
