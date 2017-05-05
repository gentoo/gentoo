# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools udev

DESCRIPTION="Library and tool for personalization of Yubico's YubiKey"
SRC_URI="https://github.com/Yubico/yubikey-personalization/archive/v${PV}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD-2"
IUSE="static-libs consolekit"

RDEPEND="
	>=sys-auth/libyubikey-1.6
	virtual/libusb:1"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	consolekit? ( sys-auth/consolekit[acl] )"

S="${WORKDIR}/yubikey-personalization-${PV}"

DOCS=( doc/. AUTHORS NEWS README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir) \
		--localstatedir=/var \
		$(use_enable static-libs static)
}

src_install() {
	default
	use consolekit && udev_dorules *.rules
}
