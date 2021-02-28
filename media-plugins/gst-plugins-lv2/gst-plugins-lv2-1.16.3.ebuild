# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Lv2 elements for Gstreamer"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE=""

RDEPEND="
	>=media-libs/lv2-1.14.0-r1[${MULTILIB_USEDEP}]
	>=media-libs/lilv-0.24.2-r2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
