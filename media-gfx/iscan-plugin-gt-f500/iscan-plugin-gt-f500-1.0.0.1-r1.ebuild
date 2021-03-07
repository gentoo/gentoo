# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_P="${PN}-$(ver_rs 3 -)"

DESCRIPTION="Epson Perfection 2480/2580 PHOTO scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.c2.i386.rpm"
S="${WORKDIR}"

LICENSE="EPSON EAPL"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="minimal"

DEPEND="minimal? ( >=media-gfx/iscan-2.21.0 )"
RDEPEND="${DEPEND}"

src_configure() { :; }
src_compile() { :; }

src_install() {
	# install scanner firmware
	insinto /usr/share/iscan
	doins "${WORKDIR}/usr/share/iscan/"*

	dodoc usr/share/doc/*/*

	use minimal && return
	# install scanner plugins
	exeinto /opt/iscan/esci
	doexe "${WORKDIR}/usr/$(get_libdir)/iscan/"*
}

pkg_postinst() {
	elog
	elog "Firmware file esfw41.bin for Epson Perfection 2480/2580 PHOTO"
	elog "has been installed in ${EROOT}/usr/share/iscan."
	elog

	use minimal && return
	[[ -n "${REPLACING_VERSIONS}" ]] && return

	# Needed for scanner to work properly.
	if [[ -z "${EROOT}" ]]; then
		iscan-registry --add interpreter usb 0x04b8 0x0121 '/opt/iscan/esci/libesint41.so.2 /usr/share/iscan/esfw41.bin' || die
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		ewarn "iscan-registry --add interpreter usb 0x04b8 0x0121 '/opt/iscan/esci/libesint41.so.2 /usr/share/iscan/esfw41.bin'"
	fi
}

pkg_prerm() {
	use minimal && return
	[[ -n "${REPLACED_BY_VERSION}" ]] && return

	if [[ -z "${EROOT}" ]]; then
		iscan-registry --remove interpreter usb 0x04b8 0x0121 '/opt/iscan/esci/libesint41.so.2 /usr/share/iscan/esfw41.bin' || die
	else
		ewarn "Unable to de-register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		ewarn "iscan-registry --remove interpreter usb 0x04b8 0x0121 '/opt/iscan/esci/libesint41.so.2 /usr/share/iscan/esfw41.bin'"
	fi
}
