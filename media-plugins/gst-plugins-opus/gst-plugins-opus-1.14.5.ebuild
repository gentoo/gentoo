# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-base

inherit gstreamer

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.1:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	gstreamer_system_link \
		gst-libs/gst/tag:gstreamer-tag \
		gst-libs/gst/pbutils:gstreamer-pbutils \
		gst-libs/gst/audio:gstreamer-audio
}

# Everything below is for building opusparse from gst-plugins-bad. Once it moves into -base, all below can be removed
SRC_URI+=" https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${PV}.tar.${GST_TARBALL_SUFFIX}"

src_configure() {
	multilib-minimal_src_configure
	S="${WORKDIR}/gst-plugins-bad-${PV}" multilib-minimal_src_configure
}

src_compile() {
	multilib-minimal_src_compile
	S="${WORKDIR}/gst-plugins-bad-${PV}" multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
	S="${WORKDIR}/gst-plugins-bad-${PV}" multilib-minimal_src_install
}
