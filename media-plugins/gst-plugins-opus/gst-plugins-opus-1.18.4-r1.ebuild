# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-base

inherit gstreamer-meson

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.1:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-opusparse-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	gstreamer_system_package audio_dep:gstreamer-audio
	gstreamer_system_package pbutils_dep:gstreamer-pbutils
	gstreamer_system_package tag_dep:gstreamer-tag
}
