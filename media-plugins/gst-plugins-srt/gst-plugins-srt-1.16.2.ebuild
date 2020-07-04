# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Secure reliable transport (SRT) transfer plugin for GStreamer"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	net-libs/srt[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.2-make43.patch # remove when bumping and switching to Meson
)
