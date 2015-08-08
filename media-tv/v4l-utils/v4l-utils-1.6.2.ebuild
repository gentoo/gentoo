# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils udev

DESCRIPTION="Separate utilities ebuild from upstream v4l-utils package"
HOMEPAGE="http://git.linuxtv.org/v4l-utils.git"
SRC_URI="http://linuxtv.org/downloads/v4l-utils/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ppc ~ppc64 sparc x86"
IUSE="qt4 udev"

RDEPEND=">=media-libs/libv4l-${PV}
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		virtual/opengl
		media-libs/alsa-lib
	)
	udev? ( virtual/libudev )
	!media-tv/v4l2-ctl
	!<media-tv/ivtv-utils-1.4.0-r2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	# Hard disable the flags that apply only to the libs.
	econf \
		--disable-static \
		$(use_enable qt4 qv4l2) \
		$(use_with udev libudev) \
		--with-udevdir="$(get_udevdir)" \
		--without-jpeg
}

src_install() {
	emake -C utils DESTDIR="${D}" install
	emake -C contrib DESTDIR="${D}" install

	dodoc README
	newdoc utils/libv4l2util/TODO TODO.libv4l2util
	newdoc utils/libmedia_dev/README README.libmedia_dev
	newdoc utils/dvb/README README.dvb
	newdoc utils/xc3028-firmware/README README.xc3028-firmware
	newdoc utils/v4l2-compliance/fixme.txt fixme.txt.v4l2-compliance
}
