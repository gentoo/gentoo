# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="UVC compliant H264 encoding cameras plugin for GStreamer"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/libgudev:=[${MULTILIB_USEDEP}]
	virtual/libusb:1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	gstreamer_system_library gstbasecamerabin_dep:libgstbasecamerabinsrc
}
