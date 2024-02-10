# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PV="$(ver_cut 1-3)"
MY_PVR="$(ver_rs 3 -)"

DESCRIPTION="Epson Perfection V600 scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.x86_64.rpm )
	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.i386.rpm )"
S="${WORKDIR}"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

QA_PREBUILT="/opt/iscan/lib/libesintA1.so*"

src_configure() { :; }
src_compile() { :; }

src_install() {
	# install scanner firmware
	insinto /usr/share/iscan
	doins "${WORKDIR}"/usr/share/iscan/*

	dodoc usr/share/doc/*/*

	# install scanner plugins
	exeinto /opt/iscan/lib
	doexe "${WORKDIR}/usr/$(get_libdir)/iscan/"*
}

pkg_postinst() {
	elog
	elog "Firmware file esfwA1.bin for Epson Perfection V600"
	elog "has been installed in ${EROOT}/usr/share/iscan."
	elog

	# Only register scanner on new installs
	[[ -n "${REPLACING_VERSIONS}" ]] && return

	# Needed for scanner to work properly.
	if [[ -z "${EROOT}" ]]; then
		iscan-registry --add interpreter usb 0x04b8 0x013a /opt/iscan/lib/libesintA1 /usr/share/iscan/esfwA1.bin || die
		elog "New firmware has been registered automatically."
		elog
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		ewarn "iscan-registry --add interpreter usb 0x04b8 0x013a /opt/iscan/lib/libesintA1 /usr/share/iscan/esfwA1.bin"
	fi
}

pkg_prerm() {
	# Only unregister on on uninstall
	[[ -n "${REPLACED_BY_VERSION}" ]] && return

	if [[ -z "${EROOT}" ]]; then
		iscan-registry --remove interpreter usb 0x04b8 0x013a /opt/iscan/lib/libesintA1 /usr/share/iscan/esfwA1.bin || die
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		ewarn "iscan-registry --remove interpreter usb 0x04b8 0x013a /opt/iscan/lib/libesintA1 /usr/share/iscan/esfwA1.bin"
	fi
}
