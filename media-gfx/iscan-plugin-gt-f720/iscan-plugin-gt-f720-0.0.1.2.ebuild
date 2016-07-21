# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit multilib versionator rpm

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"
MY_P="esci-interpreter-gt-f720-${MY_PVR}"

DESCRIPTION="Epson Perfection V300 PHOTO scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.x86_64.rpm )
	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.i386.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* amd64 x86"

IUSE=""
IUSE_LINGUAS="ja"

for X in ${IUSE_LINGUAS}; do IUSE="${IUSE} linguas_${X}"; done

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="usr/lib64/esci/libesci-interpreter-gt-f720.so*"

src_install() {
	local MY_LIB="/usr/$(get_libdir)"

	# install scanner firmware
	insinto /usr/share/esci
	doins "${WORKDIR}/usr/share/esci/"*

	# install docs
	if use linguas_ja; then
		dodoc usr/share/doc/*/AVASYSPL.ja.txt
	 else
		dodoc usr/share/doc/*/AVASYSPL.en.txt
	fi

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
