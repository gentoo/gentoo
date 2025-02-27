# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Ladspa elements for Gstreamer"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

RDEPEND="
	>=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]
	media-libs/liblrdf[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
