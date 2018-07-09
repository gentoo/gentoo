# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Ladspa elements for Gstreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
