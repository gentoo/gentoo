# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib rpm

DESCRIPTION="Epson Perfection V300 PHOTO scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://download2.ebz.epson.net/iscan/plugin/gt-f720/rpm/x64/iscan-gt-f720-bundle-1.0.1.x64.rpm.tar.gz -> ${PN}-bundle.rpm.tar.gz )
	x86? ( https://download2.ebz.epson.net/iscan/plugin/gt-f720/rpm/x86/iscan-gt-f720-bundle-1.0.1.x86.rpm.tar.gz -> ${PN}-bundle.rpm.tar.gz )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="usr/lib64/esci/libesci-interpreter-gt-f720.so*"

src_unpack() {
	unpack "${PN}-bundle.rpm.tar.gz"
	mv * "./${PN}-bundle.rpm"
	srcrpm_unpack "./${PN}-bundle.rpm/plugins/esci-interpreter-gt-f720-0.1.1-2.x86_64.rpm"
}

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
	iscan-registry --add interpreter usb 0x04b8 0x0131 "${MY_LIB}/esci/libesci-interpreter-gt-f720 /usr/share/esci/esfw8b.bin"
	elog
	elog "Firmware file esfw8b.bin for Epson Perfection V300 PHOTO"
	elog "has been installed in /usr/share/esci and registered for use."
	elog
}

pkg_prerm() {
	local MY_LIB="/usr/$(get_libdir)"

	iscan-registry --remove interpreter usb 0x04b8 0x0131 "${MY_LIB}/esci/libesci-interpreter-gt-f720 /usr/share/esci/esfw8b.bin"
}
