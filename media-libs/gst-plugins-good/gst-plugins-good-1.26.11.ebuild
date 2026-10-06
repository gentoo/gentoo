# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson verify-sig virtualx

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI+=" verify-sig? ( https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz.asc )"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="+orc"

# Old media-libs/gst-plugins-ugly blocker for xingmux moving from ugly->good
RDEPEND="
	!<media-libs/gst-plugins-ugly-1.22.3
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.41[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-tpm )"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tpm.asc

PATCHES=(
	# bug #974286
	"${FILESDIR}"/gst-plugins-good-1.26.11-GStreamer-SA-2026-0016.patch
	"${FILESDIR}"/gst-plugins-good-1.26.11-GStreamer-SA-2026-0018.patch
	"${FILESDIR}"/gst-plugins-good-1.26.11-GStreamer-SA-2026-0021.patch
	"${FILESDIR}"/gst-plugins-good-1.26.11-GStreamer-SA-2026-0022.patch
)

multilib_src_configure() {
	# gst/matroska can use bzip2
	GST_PLUGINS_NOAUTO="bz2"

	local emesonargs=(
		-Dbz2=enabled
	)

	gstreamer_multilib_src_configure
}

multilib_src_test() {
	local -a EMESON_SKIP_TESTS=(
		# known flaky test bug #930448
		# https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/2803
		elements_flvmux

		# flaky with timeouts
		elements_mpegaudioparse
	)

	# gstreamer_multilib_src_test doesn't pass arguments
	GST_GL_WINDOW=x11 virtx meson_src_test --timeout-multiplier 5
}
