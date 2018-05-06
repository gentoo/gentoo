# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="a client for signing certificates with an ACME-server"
HOMEPAGE="https://github.com/lukas2511/dehydrated"
SRC_URI="mirror://github.com/lukas2511/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/cron"
RDEPEND="
	${DEPEND}
	app-shells/bash
	net-misc/curl
"

src_configure() {
	default
	sed -i  's,^#CONFIG_D=.*,CONFIG_D="/etc/dehydrated/config.d",' docs/examples/config || die "could not set config (CONFIG_D)"
}

src_install() {
	dobin "${PN}"
	insinto "/etc/${PN}"
	doins docs/examples/{config,domains.txt,hook.sh}
	dodoc docs/*.md

	insinto /etc/"${PN}"/config.d
	doins "${FILESDIR}"/00_gentoo.sh

	insinto "/etc/cron.d"
	newins "${FILESDIR}"/cron "${PN}"

	dodir /etc/"${PN}"/config.d
	keepdir /etc/"${PN}"/config.d

	default
}

pkg_preinst() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 /var/lib/"${PN}" "${PN}"
}

pkg_postinst() {
	if [[ "${REPLACING_VERSIONS}" =~ (0\.3\.1|0\.4\.0) ]]; then
		ewarn ""
		ewarn "The new default BASEDIR is now '/var/lib/dehydrated'"
		ewarn "Please consider migrating your data with a command like"
		ewarn ""
		ewarn "  'mv -v /etc/dehydrated/{accounts,archive,certs,lock} /var/lib/dehydrated'"
		ewarn ""
		ewarn "and make sure BASEDIR is set to '/var/lib/dehydrated'"
		ewarn ""
	fi
	einfo "See /etc/dehydrated/config for configuration."
	einfo "After finishing setup you should enable the cronjob in /etc/cron.d/dehydrated."
}
