# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/alsa-firmware/alsa-firmware-1.0.29.ebuild,v 1.3 2015/05/27 12:41:42 ago Exp $

EAPI=5
inherit udev

DESCRIPTION="Advanced Linux Sound Architecture firmware"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/firmware/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

ECHOAUDIO_CARDS="alsa_cards_darla20 alsa_cards_gina20 alsa_cards_layla20
alsa_cards_darla24 alsa_cards_gina24 alsa_cards_layla24 alsa_cards_mona
alsa_cards_mia alsa_cards_indigo alsa_cards_indigoio alsa_cards_echo3g"

EMU_CARDS="alsa_cards_emu1212 alsa_cards_emu1616 alsa_cards_emu1820
alsa_cards_emu10k1"

IUSE="alsa_cards_cs46xx alsa_cards_pcxhr alsa_cards_vx222 alsa_cards_usb-usx2y alsa_cards_hdsp
alsa_cards_hdspm alsa_cards_mixart alsa_cards_asihpi alsa_cards_sb16
alsa_cards_korg1212 alsa_cards_maestro3 alsa_cards_ymfpci alsa_cards_wavefront
alsa_cards_msnd-pinnacle alsa_cards_aica alsa_cards_ca0132 ${ECHOAUDIO_CARDS}
${EMU_CARDS}"

RDEPEND="alsa_cards_usb-usx2y? ( sys-apps/fxload )
	alsa_cards_hdsp? ( media-sound/alsa-tools )
	alsa_cards_hdspm? ( media-sound/alsa-tools )"

DOCS="README"

src_configure() {
	econf --with-hotplug-dir=/lib/firmware
}

src_install() {
	default

	use alsa_cards_pcxhr || rm -rf "${ED}"/usr/share/alsa/firmware/pcxhrloader "${ED}"/lib/firmware/pcxhr
	use alsa_cards_vx222 || rm -rf "${ED}"/usr/share/alsa/firmware/vxloader "${ED}"/lib/firmware/vx
	use alsa_cards_usb-usx2y || rm -rf "${ED}"/usr/share/alsa/firmware/usx2yloader "${ED}"/lib/firmware/vx
	use alsa_cards_mixart || rm -rf "${ED}"/usr/share/alsa/firmware/mixartloader "${ED}"/lib/firmware/mixart
	use alsa_cards_hdsp || use alsa_cards_hdspm || rm -rf "${ED}"/usr/share/alsa/firmware/hdsploader
	use alsa_cards_asihpi || rm -rf "${ED}"/lib/firmware/asihpi
	use alsa_cards_sb16 || rm -rf "${ED}"/lib/firmware/sb16
	use alsa_cards_korg1212 || rm -rf "${ED}"/lib/firmware/korg
	use alsa_cards_maestro3 || rm -rf "${ED}"/lib/firmware/ess
	use alsa_cards_ymfpci || rm -rf "${ED}"/lib/firmware/yamaha
	use alsa_cards_wavefront || rm -rf "${ED}"/lib/firmware/wavefront
	use alsa_cards_msnd-pinnacle || rm -rf "${ED}"/lib/firmware/turtlebeach
	use alsa_cards_aica || rm -rf "${ED}"/lib/firmware/aica_firmware.bin
	use alsa_cards_ca0132 || rm -rf "${ED}"/lib/firmware/c{tefx,tspeq}.bin
	use alsa_cards_cs46xx || rm -rf "${ED}"/lib/firmware/cs46xx

	local ea="no"
	for card in ${ECHOAUDIO_CARDS}; do
		use ${card} && ea="yes" && break
	done

	local emu="no"
	for card in ${EMU_CARDS}; do
		use ${card} && emu="yes" && break
	done

	[[ ${ea} == "no" ]] && rm -rf "${ED}"/lib/firmware/ea
	[[ ${emu} == "no" ]] && rm -rf "${ED}"/lib/firmware/emu

	use alsa_cards_usb-usx2y && udev_dorules "${FILESDIR}"/52-usx2yaudio.rules
}
