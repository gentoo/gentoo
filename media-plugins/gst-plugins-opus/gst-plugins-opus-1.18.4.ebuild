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
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

# Everything below is for building opusparse from gst-plugins-bad. Once it moves into -base, all below can be removed
SRC_URI+=" https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${PV}.tar.${GST_TARBALL_SUFFIX}"

multilib_src_configure() {
	gstreamer_multilib_src_configure
	S="${WORKDIR}/gst-plugins-bad-${PV}" gstreamer_multilib_src_configure
}

multilib_src_compile() {
	gstreamer_multilib_src_compile
	S="${WORKDIR}/gst-plugins-bad-${PV}" gstreamer_multilib_src_compile
}

multilib_src_install() {
	gstreamer_multilib_src_install
	S="${WORKDIR}/gst-plugins-bad-${PV}" gstreamer_multilib_src_install
}
