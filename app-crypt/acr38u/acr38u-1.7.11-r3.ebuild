# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune versionator toolchain-funcs udev

MY_P=ACR38_LINUX_$(get_version_component_range 1)00$(get_version_component_range 2)$(get_version_component_range 3)_P

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Non CCID driver for ACR38 AC1038-based Smart Card Reader"

#SRC_URI="http://www.acs.com.hk/drivers/eng/${MY_P}.tar.bz2"
# tarball release is encapsuled in a .zip file :-(
# http://www.acs.com.hk/drivers/eng/ACR38_Driver_Lnx_101_P.zip
# I'm waiting an answer from info@acs.com.hk about that !
SRC_URI="http://www.linuxunderground.be/${MY_P}.tar.bz2"
HOMEPAGE="http://www.acs.com.hk"

# Make this safe from collisions, require a version of pcsc-lite that
# uses libusb-1.0 and use the wrapper library instead.
# Changed back from dev-libs/libusb-compat to virtual/libusb:0 because
# libusb-compat is marked stable and primary in the virtual. -ssuominen
RDEPEND=">=sys-apps/pcsc-lite-1.6.4
	virtual/libusb:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	prune_libtool_files --modules

	# note: for eudev support this pkg may always need to install rules to /usr
	udev_newrules "${FILESDIR}"/${PV}-bis.rules 92-pcscd-acr38u.rules
}
