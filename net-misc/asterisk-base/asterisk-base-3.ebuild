# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd tmpfiles

DESCRIPTION="Gentoo Asterisk init scripts"
HOMEPAGE="https://github.com/jkroonza/asterisk-base"
SRC_URI="https://github.com/jkroonza/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	net-misc/asterisk
	!<=net-misc/asterisk-16.30.0:0/16
	!<=net-misc/asterisk-18.18.0:0/18
	!<=net-misc/asterisk-20.3.0:0/20
"

src_install() {
	newinitd initd asterisk
	newconfd confd asterisk
	dosbin asterisk_wrapper

	systemd_dounit asterisk.service
	systemd_install_serviced asterisk.service.conf asterisk.service

	newtmpfiles tmpfiles.conf asterisk.conf

	insinto /etc/logrotate.d
	newins logrotate asterisk
}

pkg_postinst() {
	tmpfiles_process asterisk.conf
}
