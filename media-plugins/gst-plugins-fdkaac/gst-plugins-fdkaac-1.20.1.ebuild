# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Fraunhofer AAC encoder plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE="introspection orc"

RDEPEND="media-libs/fdk-aac:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
