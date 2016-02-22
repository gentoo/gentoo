# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="HTTP live streaming plugin"
KEYWORDS="amd64 ~x86"
IUSE=""

# FIXME: automagic fallback from nettle to libgcrypt to openssl
RDEPEND="
	dev-libs/nettle:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	# FIXME: gsturidownloader does not have a .pc
	# gstreamer_system_link \
	#	gst-libs/gst/uridownloader:gsturidownloader \
	#	gst-libs/gst/adaptativedemux:gstadaptivedemux

	local directory libs
	directory="gst-libs/gst/uridownloader"
	libs="-lgobject-2.0 -lglib-2.0 -lgstreamer-1.0 -lgstbase-1.0 -lgsturidownloader-1.0"
	sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
		-i ext/hls/Makefile.{am,in} || die

	directory="gst-libs/gst/adaptivedemux"
	libs="-lgobject-2.0 -lglib-2.0 -lgstreamer-1.0 -lgstbase-1.0 -lgstapp-1.0 -lgsturidownloader-1.0 -lgstadaptivedemux-1.0"
	sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
		-i ext/hls/Makefile.{am,in} || die
}
