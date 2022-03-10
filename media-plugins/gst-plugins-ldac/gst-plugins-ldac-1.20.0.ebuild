# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="LDAC plugin for GStreamer"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libldac[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

# Fixes backported to 1.20.0, to be removed in 1.20.1
PATCHES=(
	"${FILESDIR}/gst-plugins-ldac-1.20.0-ldac-payload-header.patch"
)
