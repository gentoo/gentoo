# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="HTTP client source plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm64 ppc ppc64 ~x86"

RDEPEND="
	>=net-libs/neon-0.30.0[${MULTILIB_USEDEP}]
	<=net-libs/neon-0.33.99[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
