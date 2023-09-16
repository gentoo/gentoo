# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="MPEG/DVD/SVCD/VCD video/audio multiplexing plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND=">=media-video/mjpegtools-2.1.0-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local emesonargs=(
		-Dgpl=enabled
	)

	gstreamer_multilib_src_configure
}
