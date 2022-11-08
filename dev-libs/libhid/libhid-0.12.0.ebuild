# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Provides a generic and flexible way to access and interact with USB HID devices"
HOMEPAGE="https://github.com/libusb/hidapi"
SRC_URI="https://github.com/libusb/hidapi/archive/refs/tags/hidapi-${PV}.tar.gz"
S="${WORKDIR}"/hidapi-hidapi-${PV}

# See LICENSE.txt
LICENSE="|| ( GPL-3 BSD HIDAPI )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	virtual/libudev:=
	virtual/libusb:1=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
