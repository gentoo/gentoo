# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyberjack/cyberjack-3.99.5_p05.ebuild,v 1.1 2014/02/13 22:26:00 idl0r Exp $

EAPI=5
inherit autotools versionator eutils linux-info toolchain-funcs udev

MY_PV="${PV/_p/_SP}"
MY_PV2="${PV/_p/final.SP}"
MY_P="pcsc-${PN}-${MY_PV2}"
MY_P2="${PN}-$(get_version_component_range 4 $MY_PV)"

DESCRIPTION="REINER SCT cyberJack pinpad/e-com USB user space driver library"
HOMEPAGE="http://www.reiner-sct.de/ http://www.libchipcard.de/"
SRC_URI="http://support.reiner-sct.de/downloads/LINUX/V${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fox static-libs threads +udev +usb"

# FIXME:
# xml is actually optional but the code is still used anyway. We'll have to wait
# until upstream fixed it.
COMMON_DEPEND="sys-apps/pcsc-lite
	usb? ( virtual/libusb:1 )
	fox? (
		>=x11-libs/fox-1.6
		dev-libs/libxml2
		)"
RDEPEND="${COMMON_DEPEND}
	udev? ( virtual/udev )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P2}

DOCS="ChangeLog NEWS doc/README.txt"

pkg_setup() {
	CONFIG_CHECK="~USB_SERIAL_CYBERJACK"
	linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}-install.patch"
	epatch "${FILESDIR}/${P}-manpages.patch"
	epatch "${FILESDIR}/${P}-returnvalue.patch"
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/${PN} \
		--disable-hal \
		--enable-pcsc \
		$(use_enable static-libs static) \
		$(use_enable usb nonserial) \
		$(use_enable threads) \
		$(use_enable fox xml2) \
		$(use_enable fox) \
		--with-usbdropdir="$($(tc-getPKG_CONFIG) libpcsclite --variable=usbdropdir)"
}

src_install() {
	default

	prune_libtool_files --all

	use udev && udev_newrules "${FILESDIR}"/${PN}-r1.rules 92-${PN}.rules #388329
}

pkg_postinst() {
	local conf="${EROOT}etc/${PN}/${PN}.conf"
	elog
	elog "To configure logging, key beep behaviour etc. you need to"
	elog "copy ${conf}.default"
	elog "to ${conf}"
	elog "and modify the latter as needed."
	elog
}
