# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils qmake-utils

MY_P=${PN}-src-${PV}

DESCRIPTION="GTK+ UVC Viewer"
HOMEPAGE="http://guvcview.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl libav pulseaudio qt5"

RDEPEND=">=dev-libs/glib-2.10
	media-libs/libpng:0=
	media-libs/libsdl2
	media-libs/libv4l
	>=media-libs/portaudio-19_pre
	!libav? ( >=media-video/ffmpeg-2.8:0= )
	libav? ( media-video/libav:= )
	virtual/ffmpeg
	virtual/libusb:1
	virtual/udev
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	gsl? ( >=sci-libs/gsl-1.15 )
	qt5? ( dev-qt/qtwidgets:5 )
	!qt5? ( >=x11-libs/gtk+-3.6:3 )
	!<sys-kernel/linux-headers-3.4-r2" #448260
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/os-headers
	sys-devel/autoconf-archive
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/ffmpeg3.patch"
	sed -i '/^docdir/,/^$/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	export MOC="$(qt5_get_bindir)/moc"
	econf \
		--disable-debian-menu \
		$(use_enable gsl) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt5) \
		$(use_enable !qt5 gtk3)
}
