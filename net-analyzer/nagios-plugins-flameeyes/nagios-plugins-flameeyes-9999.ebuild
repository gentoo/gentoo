# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 multilib

EGIT_REPO_URI="https://github.com/Flameeyes/${PN}.git"
SRC_URI=""
KEYWORDS=""

DESCRIPTION="Flameeyes's custom Nagios/Icinga plugins"
HOMEPAGE="https://github.com/Flameeyes/nagios-plugins-flameeyes"

LICENSE="MIT"
SLOT="0"
IUSE="smart samba"

RDEPEND="
	dev-perl/Nagios-Plugin
	sys-apps/portage
	dev-perl/Time-Duration
	dev-perl/TimeDate
	smart? (
		sys-apps/smartmontools
		app-admin/sudo
	)
	samba? ( dev-perl/Filesys-SmbClient )"
DEPEND=""

src_compile() {
	cat - > "${T}"/50${PN} <<EOF
Cmnd_Alias NAGIOS_PLUGINS_FLAMEEYES_CMDS = /usr/sbin/smartctl
User_Alias NAGIOS_PLUGINS_FLAMEEYES_USERS = nagios, icinga

NAGIOS_PLUGINS_FLAMEEYES_USERS ALL=(root) NOPASSWD: NAGIOS_PLUGINS_FLAMEEYES_CMDS
EOF
}

src_install() {
	insinto /etc/sudoers.d
	doins "${T}"/50${PN}

	dodir /usr/$(get_libdir)/nagios/plugins/flameeyes
	cp -Rp $(find . -type d -mindepth 1 -maxdepth 1 -not -name .git) \
		"${D}/usr/$(get_libdir)/nagios/plugins/flameeyes" || die

	dodoc README.md
}
