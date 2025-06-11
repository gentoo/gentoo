# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="SRTP encoder/decoder plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND=">=net-libs/libsrtp-2.1.0:2=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils"

PATCHES=(
	"${FILESDIR}"/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
)
