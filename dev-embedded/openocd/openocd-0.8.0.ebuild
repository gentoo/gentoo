# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib flag-o-matic toolchain-funcs udev

# One ebuild to rule them all
if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-2
	EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code"
else
	MY_PV="${PV/_/-}"
	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}"/${MY_P}
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${MY_PV}/${MY_P}.tar.gz"
fi

DESCRIPTION="OpenOCD - Open On-Chip Debugger"
HOMEPAGE="http://openocd.sourceforge.net"

LICENSE="GPL-2+"
SLOT="0"
IUSE="cmsis-dap dummy ftdi parport +usb verbose-io"
RESTRICT="strip" # includes non-native binaries

RDEPEND=">=dev-lang/jimtcl-0.75
	cmsis-dap? ( dev-libs/hidapi )
	usb? (
		virtual/libusb:0
		virtual/libusb:1
	)
	ftdi? ( dev-embedded/libftdi )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user

	# jimtcl-0.75 compatibility. Remove it on the
	# next version bump
	epatch "${FILESDIR}"/${P}-jimtcl-0.75.patch

	if [[ ${PV} == "9999" ]] ; then
		AT_NO_RECURSIVE=yes eautoreconf
	fi
}

src_configure() {
	# Here are some defaults
	local myconf=(
		--enable-buspirate
		--disable-werror
		--disable-internal-jimtcl
		--enable-amtjtagaccel
		--enable-ep93xx
		--enable-at91rm9200
		--enable-gw16012
		--enable-oocd_trace
		--enable-arm-jtag-ew
		--enable-sysfsgpio
		--enable-bcm2835gpio
	)

	# Adapters requiring usb/libusb-1.X support
	if use usb; then
		myconf+=(
			--enable-aice
			--enable-usb-blaster-2
			--enable-ftdi
			--enable-ti-icdi
			--enable-ulink
			--enable-osbdm
			--enable-opendous
			--enable-usbprog
			--enable-jlink
			--enable-rlink
			--enable-stlink
			--enable-vsllink
			--enable-armjtagew
			$(use_enable verbose-io verbose-usb-io)
			$(use_enable verbose-io verbose_usb_comms)
		)
	else
		myconf+=(
			--disable-aice
			--disable-usb-blaster-2
			--disable-ftdi
			--disable-ti-icdi
			--disable-ulink
			--disable-osbdm
			--disable-opendous
			--disable-usbprog
			--disable-jlink
			--disable-rlink
			--disable-stlink
			--disable-vsllink
			--disable-armjtagew
		)
	fi

	if use ftdi; then
		myconf+=(
			--enable-usb_blaster_libftdi
			--enable-openjtag_ftdi
			--enable-presto_libftdi
		)
	else
		myconf+=(
			--disable-openjtag_ftdi
			--disable-presto_libftdi
			--disable-usb_blaster_libftdi
		)
	fi

	econf \
		$(use_enable dummy) \
		$(use_enable cmsis-dap) \
		$(use_enable parport) \
		$(use_enable parport parport_ppdev) \
		$(use_enable verbose-io verbose-jtag-io) \
		"${myconf[@]}"
}

src_install() {
	default
	env -uRESTRICT prepstrip "${ED}"/usr/bin "${ED}"/usr/$(get_libdir)
	udev_dorules ${D}/usr/share/${PN}/contrib/*.rules
}
