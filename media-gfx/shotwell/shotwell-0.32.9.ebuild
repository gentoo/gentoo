# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson optfeature vala xdg

DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/shotwell"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="opencv udev"

DEPEND="
	>=x11-libs/gtk+-3.22.0:3
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/libgee-0.8.5:0.8=
	>=net-libs/webkit-gtk-2.26:4.1
	net-libs/libsoup:3.0
	>=dev-libs/json-glib-0.7.6
	>=dev-libs/libxml2-2.6.32:2
	x11-libs/gdk-pixbuf:2
	>=dev-db/sqlite-3.5.9:3
	>=media-libs/gstreamer-1.20:1.0
	>=media-libs/gst-plugins-base-1.20:1.0
	>=media-libs/libgphoto2-2.5:=
	udev? ( >=dev-libs/libgudev-145:= )
	>=media-libs/gexiv2-0.12.3
	>=media-libs/libraw-0.13.2:=
	>=media-libs/libexif-0.6.16
	app-crypt/libsecret
	>=dev-libs/libportal-0.5:=[gtk]
	media-libs/libwebp:=

	>=app-crypt/gcr-3:0=[gtk]
	x11-libs/cairo
	opencv? ( >=media-libs/opencv-4.0.0:= )
"
RDEPEND="${DEPEND}
	media-plugins/gst-plugins-gdkpixbuf:1.0
	media-plugins/gst-plugins-meta:1.0
"
BDEPEND="
	$(vala_depend)
	dev-libs/appstream-glib
	dev-libs/glib
	dev-util/gdbus-codegen
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	net-libs/libsoup:3.0[vala]
	media-libs/gexiv2[vala]
	app-crypt/gcr:0[vala]
"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dunity_support=false
		# -Dpublishers # In 0.30.2 all get compiled in anyways, even if restricted list, affects only runtime support
		#trace
		#measure
		-Ddupe_detection=true
		$(meson_use udev)
		-Dinstall_apport_hook=false
		$(meson_use opencv face_detection)
		-Dfatal_warnings=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	optfeature "Enable support for the AVIF format" media-libs/libavif[gdk-pixbuf]
	optfeature "Enable support for the HEIF format" media-libs/libheif[gdk-pixbuf]
	optfeature "Enable support for the JPEG format" x11-libs/gdk-pixbuf[jpeg]
	optfeature "Enable support for the TIFF format" x11-libs/gdk-pixbuf[tiff]
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
