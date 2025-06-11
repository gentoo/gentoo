# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="UVC compliant H264 encoding cameras plugin for GStreamer"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-libs/libgudev:=[${MULTILIB_USEDEP}]
	virtual/libusb:1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
)

src_prepare() {
	default
	gstreamer_system_library gstbasecamerabin_dep:libgstbasecamerabinsrc
}
