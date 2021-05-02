# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-base

inherit gstreamer-meson

DESCRIPTION="Visualization elements for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libvisual-0.4.0-r3[${MULTILIB_USEDEP}]
	>=media-plugins/libvisual-plugins-0.4.0-r3[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
