# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="pcsc-${PN}"
MY_PV="${PV/_p/final.SP}"
MY_P="${MY_PN}-${MY_PV}"

inherit autotools toolchain-funcs udev

DESCRIPTION="REINER SCT cyberJack USB chipcard reader user space driver"
HOMEPAGE="https://www.reiner-sct.de/"
SRC_URI="https://support.reiner-sct.de/downloads/LINUX/V${PV/_p/_SP}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P/_/-}"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="threads tools +udev xml"

RDEPEND="
	sys-apps/pcsc-lite
	virtual/libusb:1=
	udev? ( virtual/udev )
	xml? ( dev-libs/libxml2:2= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-3.99.5_p14-gcc10.patch )

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
		--enable-nonserial
		--enable-pcsc
		--enable-release
		--enable-warnings
		--sysconfdir="${EPREFIX}"/etc/cyberjack
		$(use_enable threads)
		$(use_enable udev)
		$(use_enable xml xml2)
		--with-usbdropdir="$($(tc-getPKG_CONFIG) libpcsclite --variable=usbdropdir)"
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use tools; then
		# cjBingo can't be compiled, as it's defines stuff, which got dropped
		emake -C tools/cjflash
		emake -C tools/cjgeldkarte
	fi
}

src_install() {
	default

	use tools && dobin tools/cjflash/cjflash tools/cjgeldkarte/cjgeldkarte
	use udev && udev_newrules "${FILESDIR}"/libifd-cyberjack6.udev-r1 99-cyberjack.rules

	dodoc debian/changelog doc/{LIESMICH,README}.{pdf,txt,xml}

	docinto html
	dodoc doc/{LIESMICH,README}.html

	docinto source
	dodoc doc/*.c*

	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
