# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="A client for signing certificates with an ACME-server"
HOMEPAGE="https://github.com/dehydrated-io/dehydrated"
SRC_URI="https://github.com/dehydrated-io/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"
IUSE="+cron"

RDEPEND="acct-group/dehydrated
	acct-user/dehydrated
	app-shells/bash
	net-misc/curl
	cron? ( virtual/cron )"

PATCHES=( "${FILESDIR}"/${P}-fix-CN-extraction-for-older-openssl-versions.patch )

src_configure() {
	default
	sed -i  's,^#CONFIG_D=.*,CONFIG_D="/etc/dehydrated/config.d",' docs/examples/config || die "could not set config (CONFIG_D)"
}

src_install() {
	dobin ${PN}
	insinto /etc/${PN}
	doins docs/examples/{config,domains.txt,hook.sh}
	fperms u+x /etc/${PN}/hook.sh
	dodoc docs/*.md

	insinto /etc/${PN}/config.d
	doins "${FILESDIR}"/00_gentoo.sh

	if use cron ; then
		insinto /etc/cron.d
		newins "${FILESDIR}"/cron-r1 ${PN}
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		einfo "See /etc/dehydrated/config for configuration."

		use cron && einfo "After finishing setup you should enable the cronjob in /etc/cron.d/dehydrated."
	fi
}
