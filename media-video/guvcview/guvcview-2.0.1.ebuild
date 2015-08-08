# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

MY_P=${PN}-src-${PV}

DESCRIPTION="GTK+ UVC Viewer"
HOMEPAGE="http://guvcview.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl pulseaudio"

RDEPEND=">=dev-libs/glib-2.10
	media-libs/libpng:0=
	media-libs/libsdl2
	media-libs/libv4l
	>=media-libs/portaudio-19_pre
	virtual/ffmpeg
	virtual/libusb:1
	virtual/udev
	>=x11-libs/gtk+-3.6:3
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	gsl? ( >=sci-libs/gsl-1.15 )
	!<sys-kernel/linux-headers-3.4-r2" #448260
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i '/^docdir/,/^$/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	# configure.ac is bad, see https://sourceforge.net/p/guvcview/tickets/16/
	econf \
		--disable-debian-menu \
		$(use pulseaudio || echo '--disable-pulse') \
		$(use gsl || echo '--disable-gsl')
}
