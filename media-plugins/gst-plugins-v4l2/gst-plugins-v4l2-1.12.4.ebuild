# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPION="V4L2 source/sink plugin for GStreamer"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="udev"

RDEPEND="
	>=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	udev? ( >=virtual/libgudev-208:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/os-headers
"

GST_PLUGINS_BUILD="gst_v4l2"

multilib_src_configure() {
	gstreamer_multilib_src_configure \
		--with-libv4l2 \
		$(use_with udev gudev)
}
