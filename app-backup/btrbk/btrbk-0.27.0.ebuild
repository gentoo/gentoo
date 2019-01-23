# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/digint/btrbk.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS="amd64 x86"
else
	SRC_URI="https://digint.ch/download/btrbk/releases/${P}.tar.xz"
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Tool for creating snapshots and remote backups of btrfs subvolumes"
HOMEPAGE="https://digint.ch/btrbk/"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+pv"

DEPEND=">=app-text/asciidoc-8.6.0
	app-text/xmlto"

RDEPEND="dev-lang/perl
	net-misc/openssh
	pv? ( sys-apps/pv )
	>=sys-fs/btrfs-progs-3.18.2"

src_install() {
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" SYSTEMDDIR="$(systemd_get_systemunitdir)" install
}
pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-0.26.0" ; then
		upgrade_0_26_0_warning="1"
	fi
	if has_version "<${CATEGORY}/${PN}-0.27.0" ; then
		upgrade_0_27_0_warning="1"
	fi
}
pkg_postinst() {
	if [[ "${upgrade_0_26_0_warning}" == "1" ]]; then
		ewarn "If you are using raw targets, make sure to run the"
		ewarn "\"raw_suffix2sidecar\" utility in each target directory."
	fi
	if [[ "${upgrade_0_27_0_warning}" == "1" ]]; then
		ewarn 'Due to a bugfix in the scheduler [1] [2], previously preserved'
		ewarn 'monthly/yearly backups could get deleted when upgrading to'
		ewarn 'btrbk-0.27.0.'
		ewarn ''
		ewarn 'Before upgrading to btrbk-0.27.0, make sure to stop all cron jobs'
		ewarn 'or systemd timers calling btrbk.'
		ewarn ''
		ewarn 'After upgrading, run "btrbk prune --dry-run --print-schedule" and'
		ewarn 'check if any snapshots/backups would get deleted. If you want to'
		ewarn 'forcibly preserve a snapshot/backup forever, rename it:'
		ewarn ''
		ewarn '    mv mysubvol.YYYYMMDD mysubvol.YYYYMMDD.keep_forever'
		ewarn ''
		ewarn 'Note that btrbk ignores subvolumes with unknown naming scheme, e.g.'
		ewarn '(".keep_forever" suffix in the example above).'
		ewarn ''
		ewarn '  [1] https://github.com/digint/btrbk/issues/217'
		ewarn '  [2] https://github.com/digint/btrbk/commit/719fb5f'
	fi
}
