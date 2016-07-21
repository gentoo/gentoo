# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="UVC compliant H264 encoding cameras plugin for GStreamer."
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	virtual/libgudev:0[${MULTILIB_USEDEP}]
	virtual/libusb:1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	# FIXME: gstbasecamerabin does not have a .pc
	# gstreamer_system_link \
	#   gst-libs/gst/basecamerabinsrc:gstbasecamerabinsrc

	local directory libs
	directory="gst-libs/gst/basecamerabinsrc"
	libs="-lgobject-2.0 -lglib-2.0 -lgstreamer-1.0 -lgstbase-1.0 -lgstapp-1.0 -lgstbasecamerabinsrc-1.0"
	sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
		-i sys/uvch264/Makefile.{am,in} || die
}
