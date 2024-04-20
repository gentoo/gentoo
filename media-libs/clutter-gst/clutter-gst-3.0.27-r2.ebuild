# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

HOMEPAGE="https://blogs.gnome.org/clutter/"
DESCRIPTION="GStreamer integration library for Clutter"

LICENSE="LGPL-2.1+"
SLOT="3.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="X debug +introspection udev"

# >=cogl-1.18 provides cogl-2.0-experimental
DEPEND="
	>=dev-libs/glib-2.20:2
	>=media-libs/clutter-1.20:1.0=[X=,introspection?]
	>=media-libs/cogl-1.18:1.0=[introspection?]
	>=media-libs/gstreamer-1.4:1.0[introspection?]
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=media-libs/gst-plugins-base-1.4:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.8:= )
	udev? ( dev-libs/libgudev )
"
# uses goom from gst-plugins-good
RDEPEND="${DEPEND}
	>=media-libs/gst-plugins-good-1.4:1.0
	!udev? ( media-plugins/gst-plugins-v4l2 )
"
BDEPEND="
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.11
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-video-sink-Remove-RGBx-BGRx-support.patch
)

src_configure() {
	# --enable-gl-texture-upload is experimental
	gnome2_src_configure \
		--disable-maintainer-flags \
		--enable-debug=$(usex debug yes minimum) \
		$(use_enable introspection) \
		$(use_enable udev)
}
