# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer-meson

DESCRIPTION="AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND=">=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="amrnb amrwbdec"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"
