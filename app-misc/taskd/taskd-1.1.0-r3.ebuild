# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake systemd

DESCRIPTION="Server part of Taskwarrior, a command-line todo list manager"
HOMEPAGE="https://taskwarrior.org/"
SRC_URI="https://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/gnutls:=
	sys-apps/util-linux
	sys-libs/readline:0=
"

RDEPEND="
	${DEPEND}
	acct-group/taskd
	acct-user/taskd
"

src_configure() {
	local mycmakeargs=(
		-DTASKD_DOCDIR=share/doc/${PF}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	systemd_dounit "${S}"/scripts/systemd/taskd.service

	insinto /usr/share/${PN}/pki
	doins pki/*

	insinto /usr/share/${PN}/mon
	doins mon/*

	newinitd "${FILESDIR}"/taskd.initd taskd
	newconfd "${FILESDIR}"/taskd.confd taskd

	grep ^TASKDDATA= "${FILESDIR}"/taskd.confd > 90taskd || die
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

	dosym ../../../etc/taskd/config /var/lib/taskd/config

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/taskd.logrotate taskd
}

pkg_postinst() {
	chown taskd:taskd /var/lib/taskd{,/orgs} /var/log/taskd /etc/taskd/{config,tls}

	elog "For configuration see 'man taskdrc' and edit /etc/taskd/config"
	elog "You will need to configure certificates first in order to use taskd"
	ewarn
	ewarn "Do not use 'taskd init' as this will replace the config file and set"
	ewarn "default but unsuitable paths"
	ewarn
	ewarn "In order to manage taskd via 'taskd' either relogin or run 'source /etc/profile'"
}
