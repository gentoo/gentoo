# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1

HOMEPAGE="https://blogs.gnome.org/clutter/"
DESCRIPTION="GStreamer integration library for Clutter"

LICENSE="LGPL-2.1+"
SLOT="3.0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="X debug examples +introspection udev"

# >=cogl-1.18 provides cogl-2.0-experimental
COMMON_DEPEND="
	>=dev-libs/glib-2.20:2
	>=media-libs/clutter-1.20:1.0=[X=,introspection?]
	>=media-libs/cogl-1.18:1.0=[introspection?]
	>=media-libs/gstreamer-1.4:1.0[introspection?]
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=media-libs/gst-plugins-base-1.4:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.8:= )
	udev? ( virtual/libgudev )
"
# uses goom from gst-plugins-good
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-good-1.4:1.0
	!udev? ( media-plugins/gst-plugins-v4l2 )
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.11
	virtual/pkgconfig
"

src_configure() {
	# --enable-gl-texture-upload is experimental
	gnome2_src_configure \
		--disable-maintainer-flags \
		--enable-debug=$(usex debug yes minimum) \
		$(use_enable introspection) \
		$(use_enable udev)
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins examples/{*.c,*.png,README}
	fi
}
