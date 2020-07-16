# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs udev

DESCRIPTION="CCID free software driver"
HOMEPAGE="https://ccid.apdu.fr https://github.com/LudovicRousseau/CCID"
SRC_URI="https://ccid.apdu.fr/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="twinserial kobil-midentity +usb"

RDEPEND=">=sys-apps/pcsc-lite-1.8.3
	usb? ( virtual/libusb:1 )"
DEPEND="${RDEPEND}"
BDEPEND="kernel_linux? ( virtual/pkgconfig )"

DOCS=( README.md AUTHORS )

src_configure() {
	econf \
		LEX=: \
		$(use_enable twinserial) \
		$(use_enable usb libusb)
}

src_compile() {
	default
	use kobil-midentity && emake -C contrib/Kobil_mIDentity_switch
}

src_install() {
	default

	if use kobil-midentity; then
		dosbin contrib/Kobil_mIDentity_switch/Kobil_mIDentity_switch
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
