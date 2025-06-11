# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-base

inherit gstreamer-meson

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

COMMON_DEPEND=">=media-libs/opus-1.1:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	gstreamer_system_package \
		audio_dep:gstreamer-audio \
		pbutils_dep:gstreamer-pbutils \
		tag_dep:gstreamer-tag
}

# Everything below is for building opusparse from gst-plugins-bad. Once it moves into -base, all below can be removed
SRC_URI+=" https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${PV}.tar.${GST_TARBALL_SUFFIX}"

in_bdir() {
	pushd "${BUILD_DIR}" || die
	"$@"
	popd || die
}

src_prepare() {
	default
	# This one is ugly. Don`t shoot the entertainer, he plays his best :)
	pushd "${WORKDIR}/gst-plugins-bad-${PV}"
	/usr/bin/patch -Np1 --input "${FILESDIR}"/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
	popd
}

src_configure() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi gstreamer_multilib_src_configure
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi gstreamer_multilib_src_configure
}

src_compile() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi in_bdir gstreamer_multilib_src_compile
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi in_bdir gstreamer_multilib_src_compile
}

src_install() {
	S="${WORKDIR}/gst-plugins-base-${PV}" multilib_foreach_abi in_bdir gstreamer_multilib_src_install
	S="${WORKDIR}/gst-plugins-bad-${PV}"  multilib_foreach_abi in_bdir gstreamer_multilib_src_install
}
