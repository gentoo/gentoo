# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs vcs-snapshot

HOMEPAGE="https://www.linuxtv.org/"
DESCRIPTION="Small utils for DVB to scan, zap, view signal strength"
SRC_URI="https://www.linuxtv.org/hg/dvb-apps/archive/3d43b280298c.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"
IUSE="alevt usb"

RDEPEND="
	alevt? (
		!media-video/alevt
		media-libs/libpng:0=
		media-libs/zvbi[v4l]
		sys-libs/zlib
		x11-libs/libX11
	)
	usb? ( virtual/libusb:0 )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-kernel/linux-headers
	dev-libs/libusb-compat
"
RDEPEND+="
	media-tv/dtv-scan-tables
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1.20100223-ldflags.patch
	"${FILESDIR}"/${PN}-1.1.1.20100223-alevt.patch
	"${FILESDIR}"/${PN}-1.1.1.20100223-perl526.patch
	"${FILESDIR}"/${PN}-no-ca_set_pid.patch
	"${FILESDIR}"/${PN}-glibc-2.31.patch
	"${FILESDIR}"/${PN}-1.1.1.20140321-gcc10.patch
	"${FILESDIR}"/${PN}-1.1.1.20140321-dvbdate.patch
)

src_prepare() {
	default

	# do not compile test-progs, incompatible with videodev2.h
	sed -i '/-C test/d' Makefile || die

	# remove copy of header-files
	rm -rv "${S}"/include/ || die
}

src_compile() {
	emake V=1 CC="$(tc-getCC)" $(usex usb "ttusb_dec_reset=1" "")
	use alevt && emake -C util/alevt CC="$(tc-getCC)" OPT="${CFLAGS}"
}

src_install() {
	emake V=1 prefix="${EPREFIX}/usr" libdir="${EPREFIX}/usr/$(get_libdir)" \
		$(usex usb "ttusb_dec_reset=1" "") \
		DESTDIR="${D}" INSTDIR="${T}" install

	if use alevt ; then
		dodir /usr/share/{applications,man/man1}
		emake -C util/alevt DESTDIR="${D}" install
	fi

	# rename scan to scan-dvb
	mv "${ED}"/usr/bin/scan{,-dvb} || die

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
	elog "${EPREFIX}/usr/bin/scan has been installed as scan-dvb."
}
