# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib
if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-2
	KEYWORDS=""
	EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code"
	EGIT_PROJECT="${PN}"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"
fi

DESCRIPTION="OpenOCD - Open On-Chip Debugger"
HOMEPAGE="http://openocd.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
IUSE="blaster dummy ftd2xx ftdi minidriver parport presto segger usb versaloon"
RESTRICT="strip" # includes non-native binaries

# libftd2xx is the default because it is reported to work better.
DEPEND="<dev-lang/jimtcl-0.73
	usb? ( virtual/libusb:0 )
	presto? ( dev-embedded/libftd2xx )
	ftd2xx? ( dev-embedded/libftd2xx )
	ftdi? ( dev-embedded/libftdi:0 )"
RDEPEND="${DEPEND}"

REQUIRED_USE="blaster? ( || ( ftdi ftd2xx ) ) ftdi? ( !ftd2xx )"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		sed -i -e "/@include version.texi/d" doc/${PN}.texi || die
		AT_NO_RECURSIVE=yes eautoreconf
	fi
}

src_configure() {
	# Here are some defaults
	myconf="--enable-buspirate --enable-ioutil --disable-werror
	--disable-internal-jimtcl --enable-amtjtagaccel
	--enable-ep93xx --enable-at91rm9200 --enable-gw16012
	--enable-oocd_trace"

	if use usb; then
		myconf="${myconf} --enable-usbprog --enable-jlink --enable-rlink \
			--enable-vsllink --enable-arm-jtag-ew"
	fi

	# add explicitely the path to libftd2xx
	use ftd2xx && LDFLAGS="${LDFLAGS} -L/opt/$(get_libdir)"

	if use blaster; then
		use ftdi && myconf="${myconf} --enable-usb_blaster_libftdi"
		use ftd2xx && myconf="${myconf} --enable-usb_blaster_ftd2xx"
	fi
	econf \
		$(use_enable dummy) \
		$(use_enable ftdi ft2232_libftdi) \
		$(use_enable ftd2xx ft2232_ftd2xx) \
		$(use_enable minidriver minidriver-dummy) \
		$(use_enable parport) \
		$(use_enable presto presto_ftd2xx) \
		$(use_enable segger jlink) \
		$(use_enable versaloon vsllink) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO || die
	prepstrip "${D}"/usr/bin
}
