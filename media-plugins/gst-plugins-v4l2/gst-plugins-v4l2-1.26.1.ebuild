# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPION="V4L2 source/sink plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="udev"

RDEPEND="
	>=media-libs/libv4l-1.28.1[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	udev? ( >=dev-libs/libgudev-238:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/os-headers
"

GST_PLUGINS_ENABLED="v4l2"

multilib_src_configure() {
	local emesonargs=(
		-Dv4l2-gudev=$(usex udev enabled disabled)
	)

	gstreamer_multilib_src_configure
}
