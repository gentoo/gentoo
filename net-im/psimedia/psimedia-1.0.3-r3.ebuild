# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psimedia/psimedia-1.0.3-r3.ebuild,v 1.11 2014/08/05 18:34:17 mrueg Exp $

EAPI=4

inherit eutils qt4-r2 multilib

DESCRIPTION="Psi plugin for voice/video calls"
HOMEPAGE="http://delta.affinix.com/psimedia/"
SRC_URI="http://delta.affinix.com/download/psimedia/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86"
IUSE="demo"

COMMON_DEPEND=">=dev-libs/glib-2.18
	>=media-libs/gstreamer-0.10.22:0.10
	>=media-libs/gst-plugins-base-0.10.22:0.10
	media-libs/gst-plugins-good:0.10
	>=dev-libs/liboil-0.3
	>=dev-qt/qtgui-4.4:4
	>=media-libs/speex-1.2_rc1
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-speex:0.10
	>=media-plugins/gst-plugins-vorbis-0.10.22:0.10
	>=media-plugins/gst-plugins-theora-0.10.22:0.10
	>=media-plugins/gst-plugins-alsa-0.10.22:0.10
	>=media-plugins/gst-plugins-ogg-0.10.22:0.10
	media-plugins/gst-plugins-v4l2:0.10
	media-plugins/gst-plugins-jpeg:0.10
	net-im/psi
	!<net-im/psi-0.13_rc1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -e '/^TEMPLATE/a CONFIG += ordered' -i psimedia.pro || die
	# Don't build demo if we don't need that.
	use demo || { sed -e '/^SUBDIRS[[:space:]]*+=[[:space:]]*demo[[:space:]]*$/d;' -i psimedia.pro || die; }
	# Remove support for V4L v1 because linux-headers-2.6.38 stopped shipping linux/videodev.h.
	epatch "${FILESDIR}"/${P}-linux-headers-2.6.38.patch
	epatch "${FILESDIR}"/${P}-drop-v4lsrc-gst-plugin.patch

	epatch "${FILESDIR}"/${P}-glib2.32.patch
}

src_configure() {
	# qconf generated configure script...
	./configure --no-separate-debug-info || die

	eqmake4
}

src_install() {
	insinto /usr/$(get_libdir)/psi/plugins
	doins gstprovider/libgstprovider.so

	if use demo; then
		exeinto /usr/$(get_libdir)/${PN}
		newexe demo/demo ${PN}

		# Create /usr/bin/psimedia
		cat <<-EOF > "demo/${PN}"
		#!/bin/bash

		export PSI_MEDIA_PLUGIN=/usr/$(get_libdir)/psi/plugins/libgstprovider.so
		/usr/$(get_libdir)/${PN}/${PN}
		EOF

		dobin demo/${PN}
	fi
}
