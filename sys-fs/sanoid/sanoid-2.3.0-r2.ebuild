# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd optfeature

DESCRIPTION="Policy-driven snapshot management and replication tools for OpenZFS."
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jimsalterjrs/${PN^}.git"
else
	SRC_URI="https://github.com/jimsalterjrs/${PN^}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cron"

BDEPEND="
	dev-lang/perl
	sys-apps/groff
"

RDEPEND="
	dev-lang/perl
	app-arch/gzip
	app-arch/lz4
	cron? ( virtual/cron )
	dev-perl/Capture-Tiny
	dev-perl/Config-IniFiles
	sys-apps/pv
	sys-block/mbuffer
	sys-fs/zfs
	virtual/perl-Data-Dumper
	virtual/perl-Getopt-Long
	virtual/ssh
"

DEPEND="${RDEPEND}"

src_compile() {
	perldoc -onroff -dsanoid.1 sanoid || die "Failed to compile sanoid.1"
	perldoc -onroff -dsyncoid.1 syncoid || die "Failed to compile syncoid.1"
}

DOCS="CHANGELIST LICENSE README.md"

src_prepare() {
	default
	sed -i 's|/usr/sbin|/usr/bin|g' \
		"packages/debian/sanoid.timer" \
		"packages/debian/sanoid.service" \
		"packages/debian/sanoid.sanoid-prune.service" || die
}

src_install() {
	dobin sanoid
	dobin syncoid
	doman sanoid.1 syncoid.1

	# Documents
	einstalldocs

	# Configs
	insinto /etc/sanoid
	doins sanoid.defaults.conf
	doins sanoid.conf

	# Binaries
	dobin sanoid syncoid findoid sleepymutex

	# Cron?
	if use cron; then
		insinto /etc/cron.d
		echo "#* * * * * root TZ=UTC /usr/bin/sanoid --cron" > "${PN}.cron" || die
		newins "${PN}.cron" "${PN}"
	fi

	# Systemd units
	systemd_dounit "packages/debian/sanoid.service"
	systemd_dounit "packages/debian/sanoid.timer"
	systemd_newunit "packages/debian/sanoid.sanoid-prune.service" "sanoid-prune.service"
}

pkg_postinst() {
	optfeature "lzop compression support" app-arch/lzop
	optfeature "pigz compression support" app-arch/pigz
	optfeature "zstd compression support" app-arch/zstd

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You will need to set up your ${EROOT}/etc/sanoid/sanoid.conf file before"
		elog "running sanoid for the first time. For details, please consult the"
		elog "documentation on https://github.com/jimsalterjrs/sanoid."
		if systemd_is_booted; then
			elog ""
			elog "To enable sanoid via systemd timer, run:"
			elog "  systemctl enable --now sanoid.timer"
			if use cron; then
				elog ""
				elog "or"
				elog ""
			fi
		fi
		if use cron; then
			elog "To enable sanoid via cron, uncomment the cron job in /etc/cron.d/sanoid."
		fi
	else
		elog "Removing old cache files (if any)"
		[[ -f /var/cache/sanoidsnapshots.txt ]] && rm -v /var/cache/sanoidsnapshots.txt
		[[ -f /var/cache/sanoid/snapshots.txt ]] && rm -v /var/cache/sanoid/snapshots.txt
		[[ -f /var/cache/sanoid/datasets.txt ]] && rm -v /var/cache/sanoid/datasets.txt
	fi
}
