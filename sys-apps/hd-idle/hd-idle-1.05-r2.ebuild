# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd

DESCRIPTION="Utility for spinning down hard disks after a period of idle time"
HOMEPAGE="https://hd-idle.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${PN}"

CONFIG_CHECK="~PROC_FS"

DOCS=( debian/changelog README )

src_install() {
	default
	systemd_newunit "${FILESDIR}"/hd-idle.service ${PN}.service
	systemd_install_serviced "${FILESDIR}"/hd-idle-dropin.conf
	newinitd "${FILESDIR}"/hd-idle-init hd-idle
	newconfd "${FILESDIR}"/hd-idle-conf hd-idle

	elog "The systemd unit file for hd-idle no longer sources ${EPREFIX}/etc/conf.d/hd-idle ."
	elog "Configuration is still done via ${EPREFIX}/etc/conf.d/hd-idle for OpenRC systems"
	elog "while for systemd systems, a systemd drop-in file located at"
	elog "${EPREFIX}/etc/systemd/system/hd-idle.service.d/00gentoo.conf"
	elog "is used for configuration."
}
