# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="Scripts necessary for use of vdr as a set-top-box"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.bz2"

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
	emake -s install DESTDIR="${D}" || die "make install failed"
	dodoc README TODO ChangeLog README.grub2

	# create necessary directories
	diropts -ovdr -gvdr
	keepdir "${VDR_HOME}"

	local kd
	for kd in shutdown-data merged-config-files dvd-images tmp; do
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
}

VDRSUDOENTRY="vdr ALL=NOPASSWD:/usr/share/vdr/bin/vdrshutdown-really.sh"

pkg_postinst() {
	if [[ $previous_less_than_0_5_4 = 0 ]] ; then
		einfo "\nVDR use now default the --cachedir parameter to store the epg.file"
		einfo "Please do not override this with the EPGFILE variable\n"

		einfo "svdrp port 2001 support removed\n"

		einfo "--rcu support removed, use media-plugin/vdr-rcu\n"
	fi

	elog "nvram wakeup is optional."
	elog "To make use of it emerge sys-power/nvram-wakeup."
	elog

	elog "Plugins which should be used are now set via its"
	elog "own config-file called /etc/conf.d/vdr.plugins"
	elog "or enabled via the frontend eselect vdr-plugin."
	elog

	if [[ -f "${ROOT}/etc/init.d/dvbsplash" ]]; then
		ewarn
		ewarn "You have dvbsplash installed!"
		ewarn "/etc/init.d/dvbsplash will now be deleted"
		ewarn "as it causes difficult to debug problems."
		ewarn
		rm "${ROOT}/etc/init.d/dvbsplash"
	fi

	if [[ -f "${ROOT}"/etc/conf.d/vdr.dvdswitch ]] &&
		grep -q ^DVDSWITCH_BURNSPEED= "${ROOT}"/etc/conf.d/vdr.dvdswitch
	then
		ewarn "You are setting DVDSWITCH_BURNSPEED in /etc/conf.d/vdr.dvdswitch"
		ewarn "This no longer has any effect, please use"
		ewarn "VDR_DVDBURNSPEED in /etc/conf.d/vdr.cd-dvd"
	fi
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
