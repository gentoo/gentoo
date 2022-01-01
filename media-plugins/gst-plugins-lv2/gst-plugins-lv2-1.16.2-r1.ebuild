# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

SRC_URI+=" https://dev.gentoo.org/~juippis/distfiles/tmp/gst-plugins-lv2-1.16.2-r1-gcc10.patch"

DESCRIPTION="Lv2 elements for Gstreamer"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=media-libs/lv2-1.14.0-r1[${MULTILIB_USEDEP}]
	>=media-libs/lilv-0.24.2-r2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${DISTDIR}/gst-plugins-lv2-1.16.2-r1-gcc10.patch"
)
