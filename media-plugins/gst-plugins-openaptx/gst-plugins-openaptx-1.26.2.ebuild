# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="openaptx plugin for GStreamer"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	|| (
		>=media-libs/libfreeaptx-0.1.1[${MULTILIB_USEDEP}]
		=media-libs/libopenaptx-0.2.0*[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
)
