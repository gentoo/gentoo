# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="bs2b elements for Gstreamer"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	media-libs/libbs2b[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
