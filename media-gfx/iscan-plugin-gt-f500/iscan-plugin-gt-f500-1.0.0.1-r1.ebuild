# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit multilib rpm versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Epson Perfection 2480/2580 PHOTO scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://dev.gentoo.org/~flameeyes/avasys/${MY_P}.c2.i386.rpm"

LICENSE="EPSON EAPL"
SLOT="0"
KEYWORDS="-* ~amd64"

IUSE="minimal"

DEPEND="minimal? ( >=media-gfx/iscan-2.21.0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

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

pkg_setup() {
	basecmds=(
		"iscan-registry --COMMAND interpreter usb 0x04b8 0x0121 '/opt/iscan/esci/libesint41.so.2 /usr/share/iscan/esfw41.bin'"
	)
}

pkg_postinst() {
	elog
	elog "Firmware file esfw41.bin for Epson Perfection 2480/2580 PHOTO"
	elog "has been installed in /usr/share/iscan."
	elog
	use minimal && return
	[[ -n ${REPLACING_VERSIONS} ]] && return

	# Needed for scanner to work properly.
	if [[ ${ROOT} == "/" ]]; then
		for basecmd in "${basecmds[@]}"; do
			eval ${basecmd/COMMAND/add}
		done
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		for basecmd in "${basecmds[@]}"; do
			ewarn "${basecmd/COMMAND/add}"
		done
	fi
}

pkg_prerm() {
	use minimal && return
	[[ -n ${REPLACED_BY_VERSION} ]] && return

	if [[ ${ROOT} == "/" ]]; then
		for basecmd in "${basecmds[@]}"; do
			eval ${basecmd/COMMAND/remove}
		done
	else
		ewarn "Unable to de-register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		for basecmd in "${basecmds[@]}"; do
			ewarn "${basecmd/COMMAND/remove}"
		done
	fi
}
