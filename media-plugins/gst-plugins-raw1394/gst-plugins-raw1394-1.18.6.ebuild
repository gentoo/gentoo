# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Fiwewire DV/HDV capture plugin for GStreamer"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/libiec61883-1.2.0-r1[${MULTILIB_USEDEP}]
	>=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	>=sys-libs/libavc1394-0.5.4-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="dv1394"
GST_PLUGINS_BUILD_DIR="raw1394"
