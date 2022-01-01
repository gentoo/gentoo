# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools udev

DESCRIPTION="Library and tool for personalization of Yubico's YubiKey"
SRC_URI="https://github.com/Yubico/yubikey-personalization/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="BSD-2"
IUSE="static-libs"

DEPEND="
	dev-libs/json-c:=
	>=sys-auth/libyubikey-1.6
	virtual/libusb:1"
BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig"
RDEPEND="${DEPEND}"

S="${WORKDIR}/yubikey-personalization-${PV}"

DOCS=( doc/. AUTHORS NEWS README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--libdir=/usr/$(get_libdir)
		--localstatedir=/var
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	udev_dorules 69-yubikey.rules

	find "${D}" -name '*.la' -delete || die
}
