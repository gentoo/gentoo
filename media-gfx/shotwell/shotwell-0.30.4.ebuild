# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.40"
VALA_MAX_API_VERSION="0.46"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="opencv udev"

COMMON_DEPEND="
	>=app-crypt/gcr-3:=[gtk,vala]
	>=dev-db/sqlite-3.5.9:3
	dev-libs/appstream-glib
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/json-glib-0.7.6
	dev-libs/libgdata
	>=dev-libs/libgee-0.8.5:0.8
	>=dev-libs/libxml2-2.6.32:2
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	>=media-libs/libexif-0.6.16:=
	>=media-libs/libgphoto2-2.5:=
	>=media-libs/libraw-0.13.2:=
	>=net-libs/webkit-gtk-2.4:4
	>=sys-devel/gettext-0.19.8
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22.0:3
	opencv? ( >=media-libs/opencv-2.3.0:= )
	udev? ( >=virtual/libgudev-145:= )
"
BDEPEND="
	$(vala_depend)
	dev-libs/appstream-glib
	virtual/pkgconfig
"
DEPEND="
	${COMMON_DEPEND}
	>=media-libs/gexiv2-0.10.4[vala]
	net-libs/libsoup:2.4[vala]
"
RDEPEND="
	${COMMON_DEPEND}
	dev-util/itstool
	media-plugins/gst-plugins-gdkpixbuf:1.0
	media-plugins/gst-plugins-meta:1.0
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dunity-support=false
		# -Dpublishers # In 0.30.2 all get compiled in anyways, even if restricted list, affects only runtime support
		-Dextra-plugins=true
		#trace
		#measure
		-Ddupe-detection=true
		$(meson_use udev)
		-Dinstall-apport-hook=false
		$(meson_use opencv face-detection)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
