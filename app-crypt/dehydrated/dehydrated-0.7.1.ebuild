# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/dehydrated.asc

inherit verify-sig

DESCRIPTION="A client for signing certificates with an ACME-server"
HOMEPAGE="https://dehydrated.io/"
SRC_URI="
	https://github.com/dehydrated-io/${PN}/releases/download/v${PV}/${P}.tar.gz
	verify-sig? ( https://github.com/dehydrated-io/${PN}/releases/download/v${PV}/${P}.tar.gz.asc )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+cron"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-dehydrated )"
RDEPEND="acct-group/dehydrated
	acct-user/dehydrated
	app-shells/bash
	net-misc/curl
	cron? ( virtual/cron )"

src_configure() {
	default
	sed -i  's,^#CONFIG_D=.*,CONFIG_D="/etc/dehydrated/config.d",' docs/examples/config \
		|| die "could not set config (CONFIG_D)"
}

src_install() {
	dobin ${PN}
	insinto /etc/${PN}
	doins docs/examples/{config,domains.txt,hook.sh}
	fperms u+x /etc/${PN}/hook.sh
	dodoc docs/*.md

	insinto /etc/${PN}/config.d
	newins "${FILESDIR}"/00_gentoo.sh-r1 00_gentoo.sh

	keepdir /etc/${PN}/domains.d

	doman  docs/man/dehydrated.1

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
