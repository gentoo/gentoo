# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit rpm versionator multilib

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"

DESCRIPTION="Epson Perfection V600 scanner plugin for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.x86_64.rpm )
	x86? ( https://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.i386.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE=""

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

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

pkg_setup() {
	basecmds=(
		"iscan-registry --COMMAND interpreter usb 0x04b8 0x013a /opt/iscan/lib/libesintA1 /usr/share/iscan/esfwA1.bin"
	)
}

pkg_postinst() {
	elog
	elog "Firmware file esfwA1.bin for Epson Perfection V600"
	elog "has been installed in /usr/share/iscan."
	elog

	# Only register scanner on new installs
	[[ -n ${REPLACING_VERSIONS} ]] && return

	# Needed for scanner to work properly.
	if [[ ${ROOT} == "/" ]]; then
		for basecmd in "${basecmds[@]}"; do
			eval ${basecmd/COMMAND/add}
		done
		elog "New firmware has been registered automatically."
		elog
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		for basecmd in "${basecmds[@]}"; do
			ewarn "${basecmd/COMMAND/add}"
		done
	fi
}

pkg_prerm() {
	# Only unregister on on uninstall
	[[ -n ${REPLACED_BY_VERSION} ]] && return

	if [[ ${ROOT} == "/" ]]; then
		for basecmd in "${basecmds[@]}"; do
			eval ${basecmd/COMMAND/remove}
		done
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		for basecmd in "${basecmds[@]}"; do
			ewarn "${basecmd/COMMAND/remove}"
		done
	fi
}
