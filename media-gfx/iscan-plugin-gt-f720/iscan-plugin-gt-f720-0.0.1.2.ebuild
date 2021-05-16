# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV="$(ver_cut 1-3)"
MY_PVR="$(ver_rs 3 -)"
MY_P="esci-interpreter-gt-f720-${MY_PVR}"

DESCRIPTION="Epson Perfection V300 PHOTO scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.x86_64.rpm )
	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.i386.rpm )"
S="${WORKDIR}"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* amd64 x86"

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

QA_PREBUILT="usr/lib64/esci/libesci-interpreter-gt-f720.so*"

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${WORKDIR}/usr/share/esci/"*

	# install scanner plugins
	insinto "${MY_LIB}/esci"
	insopts -m0755
	doins "${WORKDIR}/usr/$(get_libdir)/esci/"*
}

pkg_postinst() {
	local MY_LIB="/usr/$(get_libdir)"

	# Needed for scaner to work properly.
	iscan-registry --add interpreter usb 0x04b8 0x0131 "${MY_LIB}/esci/libesci-interpreter-gt-f720 /usr/share/esci/esfw8b.bin" || die
	elog
	elog "Firmware file esfw8b.bin for Epson Perfection V300 PHOTO"
	elog "has been installed in ${EROOT}/usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0131 "${MY_LIB}/esci/libesci-interpreter-gt-f720 /usr/share/esci/esfw8b.bin" || die
}
