# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/esci-interpreter-gt-s80/esci-interpreter-gt-s80-0.2.1.1.ebuild,v 1.3 2014/08/10 21:14:01 slyfox Exp $

EAPI=5

inherit rpm versionator multilib

MY_PV="$(get_version_component_range 1-3)"
MY_PVR="$(replace_version_separator 3 -)"

DESCRIPTION="Epson GT-S50 and GT-S80 scanner plugins for SANE 'epkowa' backend"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="amd64? ( http://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.x86_64.rpm )
	x86? ( http://dev.gentoo.org/~flameeyes/avasys/${PN}-${MY_PVR}.i386.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE=""

DEPEND=">=media-gfx/iscan-2.28.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="/opt/iscan/*"

src_configure() { :; }
src_compile() { :; }

src_install() {
	dodoc usr/share/doc/*/*

	# install scanner plugins
	exeinto /opt/iscan/esci
	doexe "${WORKDIR}/usr/$(get_libdir)/esci/"*
}

pkg_setup() {
	basecmds=(
		"iscan-registry --COMMAND interpreter usb 0x04b8 0x0136 /opt/iscan/esci/libesci-interpreter-gt-s80"
		"iscan-registry --COMMAND interpreter usb 0x04b8 0x0137 /opt/iscan/esci/libesci-interpreter-gt-s50"
		"iscan-registry --COMMAND interpreter usb 0x04b8 0x0144 /opt/iscan/esci/libesci-interpreter-gt-s80"
		"iscan-registry --COMMAND interpreter usb 0x04b8 0x0143 /opt/iscan/esci/libesci-interpreter-gt-s50"
	)
}

pkg_postinst() {
	[[ -n ${REPLACING_VERSIONS} ]] && return

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
