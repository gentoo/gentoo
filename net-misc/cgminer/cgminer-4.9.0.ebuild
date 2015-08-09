# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic

DESCRIPTION="Bitcoin CPU/GPU/FPGA/ASIC miner in C"
HOMEPAGE="http://bitcointalk.org/?topic=28402.msg357369 http://github.com/ckolivas/cgminer"
SRC_URI="http://ck.kolivas.org/apps/cgminer/${P}.tar.bz2"
#SRC_URI="http://ck.kolivas.org/apps/cgminer/4.5/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

HARDWARE="ants1 ants2 avalon avalon2 avalon4 bab bitmine_A1 bflsc bitforce bitfury blockerupter cointerra drillbit hashfast hashratio icarus klondike knc minion modminer spondoolies"
IUSE="doc examples udev hardened ncurses ${HARDWARE}"

REQUIRED_USE="|| ( ${HARDWARE} )"

RDEPEND="net-misc/curl
	>=dev-libs/jansson-2.6
	ncurses? ( sys-libs/ncurses )
	ants1? ( virtual/libusb:1[udev] )
	ants2? ( virtual/libusb:1[udev] )
	avalon? ( virtual/libusb:1[udev] )
	avalon2? ( virtual/libusb:1[udev] )
	avalon4? ( virtual/libusb:1[udev] )
	bflsc? ( virtual/libusb:1[udev] )
	bitforce? ( virtual/libusb:1[udev] )
	bitfury? ( virtual/libusb:1[udev] )
	blockerupter? ( virtual/libusb:1[udev] )
	cointerra? ( virtual/libusb:1[udev] )
	drillbit? ( virtual/libusb:1[udev] )
	hashfast? ( virtual/libusb:1[udev] )
	hashratio? ( virtual/libusb:1[udev] )
	icarus? ( virtual/libusb:1[udev] )
	klondike? ( virtual/libusb:1[udev] )
	modminer? ( virtual/libusb:1[udev] )
	spondoolies? ( virtual/libusb:1[udev] )
	udev? ( virtual/libudev )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.4.2-system-jansson.patch
	eautoreconf
}

src_configure() {
	use hardened && append-cflags "-nopie"

	econf $(use_with ncurses curses) \
		$(use_enable ants1) \
		$(use_enable ants2) \
		$(use_enable avalon) \
		$(use_enable avalon2) \
		$(use_enable avalon4) \
		$(use_enable bab) \
		$(use_enable bitmine_A1) \
		$(use_enable bflsc) \
		$(use_enable bitforce) \
		$(use_enable bitfury) \
		$(use_enable blockerupter) \
		$(use_enable cointerra) \
		$(use_enable drillbit) \
		$(use_enable hashfast) \
		$(use_enable hashratio) \
		$(use_enable icarus) \
		$(use_enable klondike) \
		$(use_enable knc) \
		$(use_enable minion) \
		$(use_enable modminer) \
		$(use_enable spondoolies) \
		$(use_enable udev) \
		--disable-forcecombo \
		--with-system-libusb
	# sanitize directories (is this still needed?)
	sed -i 's~^\(\#define CGMINER_PREFIX \).*$~\1"'"${EPREFIX}/usr/lib/cgminer"'"~' config.h
}

src_install() { # How about using some make install?
	dobin cgminer

	if use udev; then
		insinto /lib/udev/rules.d
		use udev && doins 01-cgminer.rules
	fi

	if use doc; then
		dodoc AUTHORS NEWS README API-README
		use icarus || use bitforce || use modminer && dodoc FPGA-README
		use avalon || use bflsc && dodoc ASIC-README
	fi

	if use examples; then
		docinto examples
		dodoc api-example.php miner.php API.java api-example.c example.conf
	fi
}
