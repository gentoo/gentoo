# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

MY_P="ACR38_LINUX_$(ver_cut 1)00$(ver_cut 2)$(ver_cut 3)_P"

DESCRIPTION="Non CCID driver for ACR38 AC1038-based Smart Card Reader"
# This driver is not maintained by ACS anymore.
# The source code is no longer available on https://www.acs.com.hk
# The download link has been updated to a stable one via the Internet Archive.
HOMEPAGE="https://www.acs.com.hk"
SRC_URI="https://web.archive.org/web/20220205194100/https://www.linuxunderground.be/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Make this safe from collisions, require a version of pcsc-lite that
# uses libusb-1.0 and use the wrapper library instead.
# Changed back from dev-libs/libusb-compat to virtual/libusb:0 because
# libusb-compat is marked stable and primary in the virtual. -ssuominen
RDEPEND="
	>=sys-apps/pcsc-lite-1.6.4
	virtual/libusb:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/cleanup.patch
	)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	# note: for eudev support this pkg may always need to install rules to /usr
	udev_newrules "${FILESDIR}/${PV}-bis.rules" 92-pcscd-acr38u.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
