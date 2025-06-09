# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Alliance for Open Media AV1 plugin for GStreamer"
KEYWORDS="~amd64 ~arm64 ~x86"

# >= 3 brings more features, and >= 3.2 even more so. Depend on >=3.2 accordingly.
RDEPEND=">=media-libs/libaom-3.2:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
)
