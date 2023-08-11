# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd tmpfiles

DESCRIPTION="Gentoo Asterisk init scripts"
HOMEPAGE="https://www.gentoo.org/wiki/No_homepage"
# Need to set S due to PMS saying we need it existing, but no SRC_URI
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	net-misc/asterisk
	!<=net-misc/asterisk-16.30.0:0/16
	!<=net-misc/asterisk-18.18.0:0/18
	!<=net-misc/asterisk-20.3.0:0/20
"

src_install() {
	newinitd "${FILESDIR}/initd-1" asterisk
	newconfd "${FILESDIR}/confd-1" asterisk
	newsbin "${FILESDIR}/asterisk_wrapper-1" asterisk_wrapper

	systemd_newunit "${FILESDIR}/asterisk.service-1" asterisk.service
	systemd_install_serviced "${FILESDIR}/asterisk.service-1.conf" asterisk.service

	newtmpfiles "${FILESDIR}/tmpfiles-1.conf" asterisk.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate-1" asterisk
}

pkg_postinst() {
	tmpfiles_process asterisk.conf
}
