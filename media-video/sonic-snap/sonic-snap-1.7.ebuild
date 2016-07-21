# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit eutils linux-info multilib toolchain-funcs

DESCRIPTION="Webcam app for sn9c10x based camera controllers (with optional MPEG4 support)"
HOMEPAGE="http://www.stolk.org/sonic-snap/"
SRC_URI="http://www.stolk.org/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="mpeg"

DEPEND="x11-libs/fltk:1
	mpeg? ( >=media-libs/libfame-0.9.1 )
	sys-libs/zlib
	x11-libs/libXdmcp
	x11-libs/libXau
	x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft"

CONFIG_CHECK="~USB_SN9C102"
ERROR_USB_SN9C102="Please make sure the SN9C1xx PC Camera Controller driver is \
enabled, under V4L USB devices, as a module in your kernel."

src_prepare() {
	# fix bad assumptions
	sed -i \
		-e "s|\$(HOME)/include|/usr/include|" \
		-e "s|\$(HOME)/lib|/usr/$(get_libdir)|" \
		-e "s|CFLAGS=|CFLAGS= ${CXXFLAGS} |" \
		-e "s|LFLAGS=|LFLAGS= ${LDFLAGS} |" \
		-e "s/g++-4.0 -O3/$(tc-getCXX)/" \
		Makefile

	use mpeg || sed -i -e "s?USE_FAME=1?USE_FAME=0?g" Makefile
}

src_compile() {
	make || die '"make" failed.'
}

src_install() {
	dodir /usr/bin
	make DESTDIR="${D}" install || die '"make install" failed.'

	dodoc ChangeLog README
	doman debian/sonic-snap.1
}

pkg_postinst() {

	elog
	elog "This driver is V4L v2 only, so V4L v1 apps will not work."
	elog "Finally, only a few image sensors are supported, eg, PAS106B"
	elog "so (check dmesg or /var/log/messages for USB device info when"
	elog "you plug the cam in)."
	elog
	elog "Now try sonic-snap-gui /dev/videoX (where X is 0, 1 , etc)."
	elog
}
