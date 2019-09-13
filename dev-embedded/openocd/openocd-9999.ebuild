# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils multilib flag-o-matic toolchain-funcs udev

# One ebuild to rule them all
if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/code"
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
IUSE="+cmsis-dap dummy +ftdi +jlink parport +usb verbose-io"
RESTRICT="strip" # includes non-native binaries

RDEPEND="
	acct-group/plugdev
	>=dev-lang/jimtcl-0.76:0=
	cmsis-dap? ( dev-libs/hidapi )
	jlink? ( dev-embedded/libjaylink )
	usb? (
		virtual/libusb:0
		virtual/libusb:1
	)
	ftdi? ( dev-embedded/libftdi:= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
[[ ${PV} == "9999" ]] && DEPEND+=" >=sys-apps/texinfo-5" #549946

src_prepare() {
	default

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
		--disable-internal-libjaylink
		--enable-amtjtagaccel
		--enable-ep93xx
		--enable-at91rm9200
		--enable-gw16012
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
			--disable-rlink
			--disable-stlink
			--disable-vsllink
			--disable-armjtagew
		)
	fi

	if use jlink; then
		myconf+=(
			--enable-jlink
		)
	else
		myconf+=(
			--disable-jlink
		)
	fi

	if use ftdi; then
		myconf+=(
			--enable-usb-blaster
			--enable-openjtag
			--enable-presto
		)
	else
		myconf+=(
			--disable-openjtag
			--disable-presto
			--disable-usb-blaster
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
	dostrip /usr/bin
	udev_dorules "${D}"/usr/share/${PN}/contrib/*.rules
}

pkg_postinst() {
	elog "To access openocd devices as user you must be in the plugdev group"
}
