# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
VALA_MIN_API_VERSION="0.54"
inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc64 ~riscv ~sparc ~x86"
IUSE="opencv udev wayland"

DEPEND="
	>=x11-libs/gtk+-3.22.0:3[wayland?]
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/libgee-0.8.5:0.8
	>=net-libs/webkit-gtk-2.26:4
	>=dev-libs/json-glib-0.7.6
	>=dev-libs/libxml2-2.6.32:2
	x11-libs/gdk-pixbuf:2
	>=dev-db/sqlite-3.5.9:3
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/libgphoto2-2.5:=
	udev? ( >=dev-libs/libgudev-145:= )
	>=media-libs/gexiv2-0.10.4
	>=media-libs/libraw-0.13.2:=
	>=media-libs/libexif-0.6.16:=
	dev-libs/libgdata
	>=app-crypt/gcr-3:=[gtk]
	x11-libs/cairo
	opencv? ( >=media-libs/opencv-2.3.0:= )
"
RDEPEND="${DEPEND}
	media-plugins/gst-plugins-gdkpixbuf:1.0
	media-plugins/gst-plugins-meta:1.0
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	net-libs/libsoup:2.4[vala]
	media-libs/gexiv2[vala]
	app-crypt/gcr[vala]
"

PATCHES=( "${FILESDIR}"/0.30.16-optional-wayland.patch )

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
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
		-Dfatal_warnings=false
		$(meson_use wayland)
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
