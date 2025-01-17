# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Adaptive demuxer plugins for Gstreamer"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	>=dev-libs/libxml2-2.8[${MULTILIB_USEDEP}]
	dev-libs/nettle:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}
	|| (
		net-libs/libsoup:3.0
		net-libs/libsoup:2.4
	)
"

multilib_src_configure() {
	local emesonargs=(
		-Dhls-crypto=nettle
	)

	gstreamer_multilib_src_configure
}
