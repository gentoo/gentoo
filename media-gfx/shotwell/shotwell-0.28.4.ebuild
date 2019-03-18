# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.28"

inherit gnome2 multilib toolchain-funcs vala

DESCRIPTION="Open source photo manager for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=app-crypt/gcr-3[gtk]
	>=dev-db/sqlite-3.5.9:3
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/json-glib-0.7.6
	>=dev-libs/libgee-0.8.5:0.8
	>=dev-libs/libxml2-2.6.32:2
	gnome-base/dconf
	>=media-libs/gexiv2-0.10.4
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gstreamer:1.0
	media-libs/lcms:2
	>=media-libs/libexif-0.6.16:=
	>=media-libs/libgphoto2-2.5:=
	>=media-libs/libraw-0.13.2:=
	media-plugins/gst-plugins-gdkpixbuf:1.0
	>=net-libs/libsoup-2.42.0:2.4
	net-libs/webkit-gtk:4
	virtual/libgudev:=[introspection]
	>=x11-libs/gtk+-3.14.0:3[X]
	dev-libs/libgdata

"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/itstool
	>=sys-devel/gettext-0.19.7
	>=sys-devel/m4-1.4.13
	virtual/pkgconfig
"

# This probably comes from libraries that
# shotwell-video-thumbnailer links to.
# Nothing we can do at the moment. #435048
QA_FLAGS_IGNORED="/usr/libexec/${PN}/${PN}-video-thumbnailer"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}
