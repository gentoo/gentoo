# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="HTTP live streaming plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/nettle:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local emesonargs=(
		-Dhls-crypto=nettle
	)

	gstreamer_multilib_src_configure
}
