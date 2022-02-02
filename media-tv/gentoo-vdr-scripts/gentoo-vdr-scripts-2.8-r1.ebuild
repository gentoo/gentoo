# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles user-info

DESCRIPTION="Scripts necessary for use of VDR as a set-top-box"
HOMEPAGE="https://gitweb.gentoo.org/proj/gentoo-vdr-scripts.git/about/"
SRC_URI="https://gitweb.gentoo.org/proj/gentoo-vdr-scripts.git/snapshot/${P}.tar.bz2 -> ${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

DEPEND="
	acct-group/vdr
	acct-user/vdr"
RDEPEND="${DEPEND}
	app-admin/sudo
	sys-process/wait_on_pid"
BDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/systemd-fix-environment.patch" )

pkg_setup() {
	VDR_HOME="$(egethome vdr)"
	echo "VDR_HOME=${VDR_HOME}"
}

src_prepare() {
	default
	cp "${FILESDIR}"/systemd-tmpfiles.conf "${WORKDIR}/${PN}.conf" || die
	sed -i -e "s|%HOME%|$VDR_HOME|" "${WORKDIR}/${PN}.conf" || die
}

src_install() {
	default
	diropts -ovdr -gvdr
	keepdir "${VDR_HOME}"
	keepdir "${VDR_HOME}/shutdown-data"
	keepdir "${VDR_HOME}/merged-config-files"
	keepdir "${VDR_HOME}/dvd-images"
	dotmpfiles "${WORKDIR}/${PN}.conf"
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "${CATEGORY}/${PN} supports an init script"
	elog "to start a X server"
	elog "Please refer for detailed info to"
	elog "/usr/share/doc/${PF}/README.x11-setup\n"

	elog "systemd is supported by ${CATEGORY}/${PN}"
	elog "Read about it in /usr/share/doc/${PF}/README.systemd"

	elog "Plugins which should be used are configured in"
	elog "the config-file /etc/conf.d/vdr.plugins"
	elog "or enable/disable them with \"eselect vdr-plugin\".\n"

	if [[ -f "${EROOT}"/etc/conf.d/vdr.dvdswitch ]] &&
		grep -q ^DVDSWITCH_BURNSPEED= "${EROOT}"/etc/conf.d/vdr.dvdswitch
	then
		ewarn "You are setting DVDSWITCH_BURNSPEED in /etc/conf.d/vdr.dvdswitch"
		ewarn "This no longer has any effect, please use"
		ewarn "VDR_DVDBURNSPEED in /etc/conf.d/vdr.cd-dvd"
	fi

	if grep -q /usr/share/vdr/bin/vdrshutdown-really.sh "${EROOT}"/etc/sudoers; then
		ewarn "Please remove the following deprecated line from /etc/sudoers:"
		ewarn "  vdr ALL=NOPASSWD:/usr/share/vdr/bin/vdrshutdown-really.sh"
		ewarn "sudoers handling is now supported by:"
		ewarn "/etc/sudoers.d/vdr"
	fi
}
