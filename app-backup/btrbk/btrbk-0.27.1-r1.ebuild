# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/digint/btrbk.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://digint.ch/download/btrbk/releases/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Tool for creating snapshots and remote backups of btrfs subvolumes"
HOMEPAGE="https://digint.ch/btrbk/"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+pv +doc"

DEPEND="doc? ( >=dev-ruby/asciidoctor-1.5.7 )"

RDEPEND="dev-lang/perl
	net-misc/openssh
	pv? ( sys-apps/pv )
	>=sys-fs/btrfs-progs-3.18.2"

src_compile() {
	use doc && emake -C doc
}
src_install() {
	local targets="install-bin install-etc install-share install-systemd"
	use doc && targets="${targets} install-man install-doc"
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" SYSTEMDDIR="$(systemd_get_systemunitdir)" ${targets}
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
