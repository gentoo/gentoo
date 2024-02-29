# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 systemd

DESCRIPTION="New script for syncing the Greenbone Community Feed"
HOMEPAGE="https://github.com/greenbone/greenbone-feed-sync"
SRC_URI="https://github.com/greenbone/greenbone-feed-sync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE="cron"

COMMON_DEPEND="
	acct-user/gvm
	net-misc/rsync
	>=net-analyzer/gvmd-22.5.0
	dev-python/tomli[${PYTHON_USEDEP}]
	>=dev-python/rich-13.2.0[${PYTHON_USEDEP}]
	>=dev-python/shtab-1.6.5[${PYTHON_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	test? ( net-analyzer/pontos[${PYTHON_USEDEP}] )
"
RDEPEND="
	${COMMON_DEPEND}
	cron? ( virtual/cron )
"

distutils_enable_tests unittest

python_install() {
	distutils-r1_python_install

	# greenbone-feed-sync should not be run as root to avoid changing file permissions
	insinto /etc/sudoers.d
	newins - greenbone-feed-sync <<-EOF
	gvm ALL = NOPASSWD: /usr/bin/greenbone-feed-sync
	EOF

	fperms 0750 /etc/sudoers.d
	fperms 0440 /etc/sudoers.d/greenbone-feed-sync

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
