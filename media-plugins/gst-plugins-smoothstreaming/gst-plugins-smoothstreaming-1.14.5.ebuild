# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Smooth Streaming plugin for GStreamer"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# FIXME: gsturidownloader does not have a .pc
	#	gst-libs/gst/uridownloader:gsturidownloader \
	#	gst-libs/gst/adaptativedemux:gstadaptivedemux \
	#	gst-libs/gst/isoff:gstisoff
	gstreamer_system_link \
		gst-libs/gst/codecparsers:gstreamer-codecparsers

	local directory libs
	directory="gst-libs/gst/uridownloader"
	libs="-lgstbase-1.0 -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0 -lgsturidownloader-1.0"
	sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
		-i ext/smoothstreaming/Makefile.{am,in} || die

	directory="gst-libs/gst/adaptivedemux"
	libs="-lgsturidownloader-1.0 -lgstapp-1.0 -lgstbase-1.0 -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0 -lgstadaptivedemux-1.0"
	sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
		-i ext/smoothstreaming/Makefile.{am,in} || die

	directory="gst-libs/gst/isoff"
	libs="-lgstbase-1.0 -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0 -lgstisoff-1.0"
	sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
		-i ext/smoothstreaming/Makefile.{am,in} || die
}
