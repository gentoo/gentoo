# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Policy-driven snapshot management and replication tools."
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cron"

RDEPEND="
	dev-lang/perl
	app-arch/gzip
	app-arch/lz4
	app-arch/lzop
	app-arch/zstd
	cron? ( virtual/cron )
	dev-perl/Capture-Tiny
	dev-perl/Config-IniFiles
	sys-apps/pv
	sys-block/mbuffer
	virtual/ssh
"
DEPEND="${RDEPEND}"

DOCS="CHANGELIST LICENSE README.md"

src_prepare() {
	default
	sed -i 's|/usr/sbin|/usr/bin|g' \
		"packages/debian/sanoid.timer" \
		"packages/debian/sanoid.service" \
		"packages/debian/sanoid.sanoid-prune.service" || die
}

src_install() {
	# Documents
	einstalldocs
	# Configs
	insinto /etc/sanoid
	doins sanoid.defaults.conf
	doins sanoid.conf
	# Binaries
	dobin sanoid syncoid findoid sleepymutex
	# cron?
	if use cron; then
		insinto /etc/cron.d
		echo "#* * * * * root TZ=UTC /usr/bin/sanoid --cron" > "${PN}.cron" || die
		newins "${PN}.cron" "${PN}"
	fi
	# systemd units
	systemd_dounit "packages/debian/sanoid.service"
	systemd_dounit "packages/debian/sanoid.timer"
	systemd_dounit "packages/debian/sanoid.sanoid-prune.service"
}

pkg_postinst() {
	elog "Removing old cache files (if any)"
	[[ -f /var/cache/sanoidsnapshots.txt ]] && rm -v /var/cache/sanoidsnapshots.txt
	[[ -f /var/cache/sanoid/snapshots.txt ]] && rm -v /var/cache/sanoid/snapshots.txt
	[[ -f /var/cache/sanoid/datasets.txt ]] && rm -v /var/cache/sanoid/datasets.txt

	elog "Edit the /etc/sanoid/sanoid.conf file to configure sanoid."
	if systemd_is_booted; then
		elog "To enable sanoid via systemd timer, run:"
		elog "  systemctl enable --now sanoid.timer"
	fi
	if use cron && systemd_is_booted; then
		elog "OR"
	fi
	if use cron; then
		elog "To enable sanoid via cron, uncomment the cron job in /etc/cron.d/sanoid."
	fi
}
