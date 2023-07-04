# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 systemd

DESCRIPTION="New script for syncing the Greenbone Community Feed"
HOMEPAGE="https://github.com/greenbone/greenbone-feed-sync"
SRC_URI="https://github.com/greenbone/greenbone-feed-sync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="cron"
RESTRICT="test"

DEPEND="
	acct-user/gvm
	net-misc/rsync
	>=net-analyzer/gvmd-22.5.0
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
"

RDEPEND="
	${DEPEND}
	cron? ( virtual/cron )
"

python_install() {
	distutils-r1_python_install

	#greenbone-feed-sync should not be run as root to avoid changing file permissions
	insinto /etc/sudoers.d
	newins - greenbone-feed-sync <<-EOF
	gvm ALL = NOPASSWD: /usr/bin/greenbone-feed-sync
EOF

	if use cron; then
		exeinto /etc/cron.daily
		newexe "${FILESDIR}"/${PN}.cron ${PN}
	fi

	systemd_dounit "${FILESDIR}/${PN}.timer" "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		return
	fi

	if use cron; then
		elog
		elog "Edit ${EROOT}/etc/cron.weekly/greenbone-feed-sync to activate daily feed update!"
		elog
	fi

	if systemd_is_booted; then
		elog
		elog "To enable the systemd timer, run the following command:"
		elog "   systemctl enable --now greenbone-feed-sync.timer"
		elog
	fi
}
