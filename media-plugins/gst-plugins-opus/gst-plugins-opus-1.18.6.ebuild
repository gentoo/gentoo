# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-base

inherit gstreamer-meson

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.1:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	!media-plugins/gst-plugins-opusparse
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	gstreamer_system_package audio_dep:gstreamer-audio
	gstreamer_system_package pbutils_dep:gstreamer-pbutils
	gstreamer_system_package tag_dep:gstreamer-tag
}

# Everything below is for building opusparse from gst-plugins-bad. Once it moves into -base, all below can be removed
SRC_URI+=" https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${PV}.tar.${GST_TARBALL_SUFFIX}"

in_bdir() {
	pushd "${BUILD_DIR}" || die
	"$@"
	popd || die
}

src_configure() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi gstreamer_multilib_src_configure
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi gstreamer_multilib_src_configure
}

src_compile() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi in_bdir gstreamer_multilib_src_compile
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi in_bdir gstreamer_multilib_src_compile
}

multilib_src_test() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi in_bdir gstreamer_multilib_src_test
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi in_bdir gstreamer_multilib_src_test
}

src_install() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi in_bdir gstreamer_multilib_src_install
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi in_bdir gstreamer_multilib_src_install
}
