# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gstreamer-meson

DESCRIPTION="A GStreamer based RTSP server"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"

LICENSE="LGPL-2+"
KEYWORDS="amd64 x86"
IUSE="examples +introspection static-libs"

# gst-plugins-base for many used elements and API
# gst-plugins-good for rtprtxsend and rtpbin elements, maybe more
# gst-plugins-srtp for srtpenc and srtpdec elements
RDEPEND="
	>=media-libs/gstreamer-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-plugins/gst-plugins-srtp-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
"
DEPEND="${RDEPEND}"
BDEPEND=""

multilib_src_configure() {
	local emesonargs=(
		-Dintrospection=$(multilib_native_usex introspection enabled disabled)
	)

	gstreamer_multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs

	if use examples ; then
		docinto examples
		dodoc "${S}"/examples/*.c
	fi
}
