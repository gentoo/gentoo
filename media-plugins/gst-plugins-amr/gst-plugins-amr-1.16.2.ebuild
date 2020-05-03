# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

DESCRIPTION="AMRNB encoder/decoder and AMRWB decoder plugin for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/opencore-amr-0.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="amrnb amrwb"
GST_PLUGINS_BUILD_DIR="amrnb amrwbdec"
