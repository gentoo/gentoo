# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

MY_PN="yubikey-personalization"

DESCRIPTION="Library and tool for personalization of Yubico's YubiKey"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization"
SRC_URI="https://github.com/Yubico/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"

RDEPEND="dev-libs/json-c:=
	>=sys-auth/libyubikey-1.6
	virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="app-text/asciidoc
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.20.0-fix-gcc10-fno-common.patch
	"${FILESDIR}"/${PN}-1.20.0-json-boolean.patch
)

DOCS=( doc/. AUTHORS NEWS README )

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--libdir=/usr/$(get_libdir)
		--localstatedir=/var
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	udev_dorules 69-yubikey.rules

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
