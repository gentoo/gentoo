# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

STUPID_NUM="4187"

inherit eutils toolchain-funcs udev autotools-utils

DESCRIPTION="CCID free software driver"
HOMEPAGE="http://pcsclite.alioth.debian.org/ccid.html"
SRC_URI="http://alioth.debian.org/frs/download.php/file/${STUPID_NUM}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="twinserial kobil-midentity +usb"

RDEPEND=">=sys-apps/pcsc-lite-1.8.3
	usb? ( virtual/libusb:1 )"
DEPEND="${RDEPEND}
	kernel_linux? ( virtual/pkgconfig )"

DOCS=( README AUTHORS )

src_configure() {
	local myeconfargs=(
		LEX=:
		$(use_enable twinserial)
		$(use_enable usb libusb)
	)

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use kobil-midentity && autotools-utils_src_compile contrib/Kobil_mIDentity_switch
}

src_install() {
	autotools-utils_src_install

	if use kobil-midentity; then
		dosbin "${BUILD_DIR}"/contrib/Kobil_mIDentity_switch/Kobil_mIDentity_switch
		doman contrib/Kobil_mIDentity_switch/Kobil_mIDentity_switch.8
	fi

	if use kernel_linux; then
		# note: for eudev support, rules probably will always need to be
		# installed to /usr

		# ccid >=1.4.11 version changed the rules drastically in a minor
		# release to no longer use the pcscd group. Using the old ones in
		# the mean time.
		udev_newrules "${FILESDIR}"/92_pcscd_ccid-2.rules 92-pcsc-ccid.rules

		# disable Kobil_mIDentity_switch udev rule with USE=-kobil-midentity
		if ! use kobil-midentity; then
			sed \
				-e '/Kobil_mIDentity_switch/s/^/#/' \
				-i "${D}/$(get_udevdir)"/rules.d/92-pcsc-ccid.rules || die
		fi

	fi
}
