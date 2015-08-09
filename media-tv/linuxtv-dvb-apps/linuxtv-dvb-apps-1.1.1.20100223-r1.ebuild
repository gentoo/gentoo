# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs vcs-snapshot

HOMEPAGE="http://www.linuxtv.org/"
DESCRIPTION="small utils for DVB to scan, zap, view signal strength, ..."
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="alevt test usb"

RDEPEND="alevt? ( !media-video/alevt
		media-libs/libpng
		media-libs/zvbi[v4l]
		sys-libs/zlib
		x11-libs/libX11 )
	usb? ( virtual/libusb:0 )
	!dev-db/xbase"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/linuxtv-dvb-headers"
# !dev-db/xbase (bug #208596)

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-alevt.patch

	# do not compile test-progs, incompartible with videodev2.h
	sed -e '/-C test/d' \
		-i Makefile || die

	# remove copy of header-files
	rm -rf "${S}"/include || die
}

src_compile() {
	emake V=1 CC=$(tc-getCC) $(usex usb "ttusb_dec_reset=1" "")
	if use alevt ; then
		emake -C util/alevt CC=$(tc-getCC) OPT="${CFLAGS}"
	fi
}

src_install() {
	insinto /usr/bin
	emake V=1 prefix="${EROOT}usr" libdir="${EROOT}usr/$(get_libdir)" \
		$(usex usb "ttusb_dec_reset=1" "") \
		DESTDIR="${D}" INSTDIR="${T}" install
	if use alevt ; then
		dodir /usr/share/applications
		dodir /usr/share/man/man1
		emake -C util/alevt DESTDIR="${D}" install
	fi

	# rename scan to scan-dvb
	mv "${D}"/usr/bin/scan{,-dvb} || die

	# install zap-files
	local dir=""
	for dir in dvb-{s,c,t} atsc ; do
		insinto /usr/share/dvb/zap/${dir}
		doins "${S}"/util/szap/channels-conf/${dir}/*
	done

	# install remote-key files
	insinto /usr/share/dvb/av7110_loadkeys
	doins util/av7110_loadkeys/*.rc*

	# install Documentation
	dodoc README
	newdoc util/scan/README README.scan-dvb
	newdoc util/szap/README README.zap
	newdoc util/av7110_loadkeys/README README.av7110_loadkeys

	use usb && newdoc util/ttusb_dec_reset/README README.ttusb_dec_reset
}

pkg_postinst() {
	elog "/usr/bin/scan has been installed as scan-dvb."
}
