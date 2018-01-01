# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Scripts for btrfs maintenance tasks like periodic scrub, balance, trim or defrag"
HOMEPAGE="https://github.com/kdave/btrfsmaintenance"
SRC_URI="https://github.com/kdave/btrfsmaintenance/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-fs/btrfs-progs
	virtual/cron"

src_install() {
	dodoc README.md CONTRIBUTING.md btrfsmaintenance.changes
	insinto /etc/default
	newins sysconfig.btrfsmaintenance btrfsmaintenance
	insinto /usr/share/btrfsmaintenance
	doins btrfsmaintenance-functions
	exeinto /usr/share/btrfsmaintenance
	doexe btrfs*.sh
	insinto /usr/lib/systemd/system
	doins btrfsmaintenance-refresh.service
}

pkg_postinst() {
	elog "Installing default btrfsmaintenance scripts"
	"${EROOT%/}"/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh || die
	elog "Now edit cron periods and mount points in /etc/default/btrfsmaintenance"
	elog "then run /usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh to"
	elog "update cron symlinks"
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		elog "Removing symlinks from btrfsmaintenance cron tasks"
		"${EROOT%/}"/usr/share/btrfsmaintenance/btrfsmaintenance-refresh-cron.sh uninstall || die
	fi
}
