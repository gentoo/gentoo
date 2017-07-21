# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="Scripts for btrfs maintenance tasks like periodic scrub, balance, trim or defrag"
HOMEPAGE="https://github.com/kdave/btrfsmaintenance"
SRC_URI="https://github.com/kdave/btrfsmaintenance/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

DEPEND=""
RDEPEND="${DEPEND}
	sys-fs/btrfs-progs
	|| (
		virtual/cron
		systemd? ( sys-apps/systemd )
	)"

src_install() {
	dodoc README.md CONTRIBUTING.md btrfsmaintenance.changes

	insinto /etc/default
	newins sysconfig.btrfsmaintenance btrfsmaintenance

	insinto /usr/share/btrfsmaintenance
	doins btrfsmaintenance-functions

	exeinto /usr/share/btrfsmaintenance
	doexe btrfs*.sh
	doexe "${FILESDIR}"/*.sh

	if use systemd; then
		insinto "$(systemd_get_systemunitdir)"
		doins btrfsmaintenance-refresh.service
		doins "${FILESDIR}"/*.timer
		doins "${FILESDIR}"/*.service
	fi
}

pkg_postinst() {
	elog "Installing default btrfsmaintenance scripts"
	if use systemd; then
		"${EROOT%/}"/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-timers.sh || die
		elog "Now edit cron periods and mount points in /etc/default/btrfsmaintenance"
		elog "then run /usr/share/btrfsmaintenance/btrfsmaintenance-refresh-timers.sh to"
		elog "update the systemd timers"
	else
		"${EROOT%/}"/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh || die
		elog "Now edit cron periods and mount points in /etc/default/btrfsmaintenance"
		elog "then run /usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh to"
		elog "update cron symlinks"
	fi
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		elog "Removing symlinks from btrfsmaintenance cron tasks"
		"${EROOT%/}"/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh uninstall || die
		if use systemd; then
			elog "Removing symlinks from btrfsmaintenance systemd timers"
			"${EROOT%/}"/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-timers.sh uninstall || die
		fi
	fi
}
