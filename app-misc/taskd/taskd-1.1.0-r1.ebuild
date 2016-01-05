# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils systemd user

DESCRIPTION="the server part of Taskwarrior, a command-line todo list manager"
HOMEPAGE="http://taskwarrior.org/"
SRC_URI="http://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/readline:0
	net-libs/gnutls
	sys-apps/util-linux"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DTASKD_DOCDIR=share/doc/${PF}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	systemd_dounit "${S}"/scripts/systemd/taskd.service

	insinto /usr/share/${PN}/pki
	doins pki/*

	insinto /usr/share/${PN}/mon
	doins mon/*

	newinitd "${FILESDIR}"/taskd.initd taskd
	newconfd "${FILESDIR}"/taskd.confd taskd

	grep ^TASKDDATA= "${FILESDIR}"/taskd.confd > 90taskd
	doenvd 90taskd

	dodir /etc/taskd
	keepdir /usr/libexec/taskd

	diropts -m 0750
	dodir /var/lib/taskd
	keepdir /var/log/taskd

	diropts -m 0700
	keepdir /var/lib/taskd/orgs /etc/taskd/tls

	insopts -m0600
	insinto /etc/taskd
	doins "${FILESDIR}"/config

	dosym /etc/taskd/config /var/lib/taskd/config

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/taskd.logrotate taskd
}

pkg_setup() {
	enewgroup taskd
	enewuser taskd -1 -1 /var/lib/taskd taskd
}

pkg_postinst() {
	chown taskd:taskd /var/lib/taskd{,/orgs} /var/log/taskd /etc/taskd/{config,tls}

	einfo ""
	einfo "For configuration see 'man taskdrc' and edit /etc/taskd/config"
	einfo "You will need to configure certificates first in order to use taskd"
	einfo ""
	ewarn ""
	ewarn "Do not use 'taskd init' as this will replace the config file and set"
	ewarn "default but unsuitable paths"
	ewarn ""
	ewarn "In order to manage taskd via 'taskd' either relogin or run 'source /etc/profile'"
	ewarn ""
}
