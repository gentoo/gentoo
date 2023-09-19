# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Alliance for Open Media AV1 plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection +orc"

RDEPEND="
	media-libs/libaom:0=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
	>=media-libs/gst-plugins-base-1.18.4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
