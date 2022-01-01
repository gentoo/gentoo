# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake udev linux-info

DESCRIPTION="Provides library functionality for FIDO 2.0"
HOMEPAGE="https://github.com/Yubico/libfido2"
SRC_URI="https://github.com/Yubico/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 ~sparc x86"
IUSE="libressl +static-libs"

DEPEND="
	dev-libs/libcbor:=
	virtual/libudev:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"

RDEPEND="
	${DEPEND}
	acct-group/plugdev
"

PATCHES=(
	"${FILESDIR}/libfido2-1.5.0-cmakelists.patch"
)

pkg_pretend() {
	CONFIG_CHECK="
		~USB_HID
		~HIDRAW
	"

	check_extra_config
}

src_install() {
	cmake_src_install

	if ! use static-libs; then
		rm -f "${ED}/$(get_libdir)"/*.a || die
	fi

	udev_newrules udev/70-u2f.rules 70-libfido2-u2f.rules
}
