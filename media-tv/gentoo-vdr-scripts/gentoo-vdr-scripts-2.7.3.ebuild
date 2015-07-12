# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/gentoo-vdr-scripts/gentoo-vdr-scripts-2.7.3.ebuild,v 1.2 2015/07/12 20:49:43 hd_brummy Exp $

EAPI=5

inherit eutils user

DESCRIPTION="Scripts necessary for use of vdr as a set-top-box"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="nvram"

RDEPEND="nvram? ( sys-power/nvram-wakeup )
	app-admin/sudo
	sys-process/wait_on_pid"

VDR_HOME=/var/vdr

pkg_setup() {
	enewgroup vdr

	# Add user vdr to these groups:
	#   video - accessing dvb-devices
	#   audio - playing sound when using software-devices
	#   cdrom - playing dvds/audio-cds ...
	enewuser vdr -1 /bin/bash "${VDR_HOME}" vdr,video,audio,cdrom
}

src_prepare() {
	# moved into own package
	sed -e '/SUBDIRS =/s# bin # #' -i usr/Makefile
	sed -e '/all:/s#compile##' -i Makefile
}

src_install() {
	default
	dodoc README* TODO ChangeLog

	# create necessary directories
	diropts -ovdr -gvdr
	keepdir "${VDR_HOME}"

	local kd
	for kd in shutdown-data merged-config-files dvd-images; do
		keepdir "${VDR_HOME}/${kd}"
	done
}

pkg_preinst() {
	local PLUGINS_NEW=0
	if [[ -f "${ROOT}"/etc/conf.d/vdr.plugins ]]; then
		PLUGINS_NEW=$(grep -v '^#' "${ROOT}"/etc/conf.d/vdr.plugins |grep -v '^$'|wc -l)
	fi
	if [[ ${PLUGINS_NEW} > 0 ]]; then
		cp "${ROOT}"/etc/conf.d/vdr.plugins "${D}"/etc/conf.d/vdr.plugins
	else
		einfo "Migrating PLUGINS setting from /etc/conf.d/vdr to /etc/conf.d/vdr.plugins"
		local PLUGIN
		for PLUGIN in $(source "${ROOT}"/etc/conf.d/vdr;echo $PLUGINS); do
			echo ${PLUGIN} >> "${D}"/etc/conf.d/vdr.plugins
		done
	fi

	has_version "<${CATEGORY}/${PN}-0.5.4"
	previous_less_than_0_5_4=$?

	has_version "<${CATEGORY}/${PN}-2.6"
	previous_less_than_2_6=$?
}

VDRSUDOENTRY="vdr ALL=NOPASSWD:/usr/share/vdr/bin/vdrshutdown-really.sh"

pkg_postinst() {
	if [[ $previous_less_than_0_5_4 = 0 ]] ; then
		elog "\nVDR use now default the --cachedir parameter to store the epg.file"
		elog "Please do not override this with the EPGFILE variable\n"

		elog "svdrp port 2001 support removed\n"

		elog "--rcu support removed, use media-plugin/vdr-rcu\n"
	fi

	if [[ $previous_less_than_2_6 = 0 ]]; then
		elog "${CATEGORY}/${PN} supports now a init script"
		elog "to start a X server"
		elog "Please refer for detailed info to"
		elog "${CATGORY}/${PN} README.x11-setup\n"
	fi

	if use nvram; then
		elog "nvram wakeup is optional."
		elog "To make use of it emerge sys-power/nvram-wakeup.\n"
	fi

	elog "Plugins which should be used are now set via its"
	elog "own config-file called /etc/conf.d/vdr.plugins"
	elog "or enabled via the frontend eselect vdr-plugin.\n"

	if [[ -f "${ROOT}"/etc/conf.d/vdr.dvdswitch ]] &&
		grep -q ^DVDSWITCH_BURNSPEED= "${ROOT}"/etc/conf.d/vdr.dvdswitch
	then
		ewarn "You are setting DVDSWITCH_BURNSPEED in /etc/conf.d/vdr.dvdswitch"
		ewarn "This no longer has any effect, please use"
		ewarn "VDR_DVDBURNSPEED in /etc/conf.d/vdr.cd-dvd"
	fi

	elog "systemd is supported by ${CATEGORY}/${PN}"
	elog "Please read for detailed info on this"
	elog "${CATEGORY}/${PN} README.systemd"
}

pkg_config() {
	if grep -q /usr/share/vdr/bin/vdrshutdown-really.sh "${ROOT}"/etc/sudoers; then

		einfo "Removing depricated entry from /etc/sudoers:"
		einfo "-  ${VDRSUDOENTRY}"

		cd "${T}"
		cat >sudoedit-vdr.sh <<-SUDOEDITOR
			#!/bin/bash
			sed -i \${1} -e '/\/usr\/share\/vdr\/bin\/vdrshutdown-really.sh *$/d'

		SUDOEDITOR
		chmod a+x sudoedit-vdr.sh

		VISUAL="${T}"/sudoedit-vdr.sh visudo -f "${ROOT}"/etc/sudoers || die "visudo failed"

		einfo "Edited /etc/sudoers"
	fi
}
