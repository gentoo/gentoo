# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="pcsc-${PN}"
MY_PV="${PV/_p/final.SP}"
MY_P="${MY_PN}-${MY_PV}"

inherit autotools flag-o-matic linux-info toolchain-funcs udev

DESCRIPTION="REINER SCT cyberJack USB chipcard reader user space driver"
HOMEPAGE="https://www.reiner-sct.de/"
SRC_URI="http://kernelport.com/reiner-sct/SP$(ver_cut 5)/${MY_P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
IUSE="static-libs threads tools +udev +usb xml"

RDEPEND="
	sys-apps/pcsc-lite
	usb? ( virtual/libusb:1 )
	udev? ( virtual/udev )
	xml? ( dev-libs/libxml2:2= )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P/_/-}"

CONFIG_CHECK="~USB_SERIAL_CYBERJACK"

pkg_setup() {
	# Add workaround for GCC-10,
	# by defining narrowing as warning like GCC-9 did.
	# Upstream is working on that.
	append-cxxflags -Wno-narrowing
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-debug
		--disable-error-on-warning
		--disable-hal
		--disable-mac-universal
		--disable-mac-arches-i386
		--disable-mac-arches-x86_64
		--disable-visibility
		--enable-pcsc
		--enable-release
		--enable-warnings
		--sysconfdir="/etc/cyberjack"
		$(use_enable static-libs static)
		$(use_enable threads)
		$(use_enable udev)
		$(use_enable usb nonserial)
		$(use_enable xml xml2)
		--with-usbdropdir="$($(tc-getPKG_CONFIG) libpcsclite --variable=usbdropdir)"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use tools; then
		# cjBingo can't be compiled, as it's defines stuff, which got dropped
		cd "${S}"/tools/cjflash && emake
		cd "${S}"/tools/cjgeldkarte && emake
	fi
}

src_install() {
	default

	use tools && dobin tools/cjflash/cjflash tools/cjgeldkarte/cjgeldkarte
	use udev && udev_newrules debian/libifd-cyberjack6.udev 99-${PN}.rules

	dodoc debian/changelog doc/{LIESMICH,README}.{pdf,txt,xml}

	docinto html
	dodoc doc/{LIESMICH,README}.html

	docinto source
	dodoc doc/*.c*

	find "${D}" -name '*.la' -delete || die
}
