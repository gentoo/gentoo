# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="X11 video capture stream plugin for GStreamer"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXdamage-1.1.4-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

GST_PLUGINS_BUILD_DIR="ximage"

multilib_src_configure() {
	local emesonargs=(
		-Dximagesrc=enabled
		-Dximagesrc-xshm=enabled
		-Dximagesrc-xfixes=enabled
		-Dximagesrc-xdamage=enabled
	)

	gstreamer_multilib_src_configure
}
