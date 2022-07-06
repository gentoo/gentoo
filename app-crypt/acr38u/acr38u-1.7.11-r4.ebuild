# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs udev

MY_P=ACR38_LINUX_$(ver_cut 1)00$(ver_cut 2)$(ver_cut 3)_P

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Non CCID driver for ACR38 AC1038-based Smart Card Reader"

#SRC_URI="http://www.acs.com.hk/drivers/eng/${MY_P}.tar.bz2"
# tarball release is encapsuled in a .zip file :-(
# http://www.acs.com.hk/drivers/eng/ACR38_Driver_Lnx_101_P.zip
# This drivers is not maintained by ACS anymore.
SRC_URI="https://www.linuxunderground.be/${MY_P}.tar.bz2"
HOMEPAGE="https://www.acs.com.hk"

# Make this safe from collisions, require a version of pcsc-lite that
# uses libusb-1.0 and use the wrapper library instead.
# Changed back from dev-libs/libusb-compat to virtual/libusb:0 because
# libusb-compat is marked stable and primary in the virtual. -ssuominen
RDEPEND=">=sys-apps/pcsc-lite-1.6.4
	virtual/libusb:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	# note: for eudev support this pkg may always need to install rules to /usr
	udev_newrules "${FILESDIR}/${PV}-bis.rules" 92-pcscd-acr38u.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
