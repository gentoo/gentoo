# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="HTTP client source plugin for GStreamer"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=net-libs/neon-0.30.0[${MULTILIB_USEDEP}]
	<=net-libs/neon-0.31.99[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# Upstream commit f10b424418e4 port to autotools
	sed -e 's|0[.]30[.]99|0.31.99|g' -i configure || die
}
