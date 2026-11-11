# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver go-module systemd

DESCRIPTION="Icinga configuration and state database supporting multiple environments"
HOMEPAGE="https://icinga.com/docs/icinga-db/"
SRC_URI="
	https://github.com/Icinga/icingadb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~sbraz/distfiles/${P}-deps.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.27"
RDEPEND="
	acct-user/icinga
	acct-group/icinga
"

DOCS=( config.example.yml doc README.md schema )

src_prepare() {
	default
	sed -e "s|@EPREFIX@|${EPREFIX}|" "${FILESDIR}/icingadb.service" > "${T}/icingadb.service" || die
}

src_compile() {
	local cmd
	for cmd in icingadb icingadb-migrate; do
		pushd "cmd/${cmd}" || die
		ego build
		popd || die
	done
}

src_install() {
	local cmd
	for cmd in icingadb icingadb-migrate; do
		dobin "cmd/${cmd}/${cmd}"
	done
	einstalldocs

	newinitd "${FILESDIR}/icingadb.initd" "${PN}"
	systemd_dounit "${T}/icingadb.service"

	keepdir /etc/icingadb
	keepdir /var/log/icingadb

	fperms 0750 /etc/icingadb /var/log/icingadb
	fowners icinga:icinga /etc/icingadb /var/log/icingadb
}

pkg_postinst() {
	local v sql=()
	for v in 1.1.1 1.2.0 1.2.1 1.4.0 1.6.0; do
		ver_replacing -lt ${v} && sql+=( ${v} )
	done
	if [[ ${#sql[@]} -gt 0 ]]; then
		ewarn "One or more database schema upgrades are needed:"
		for v in "${sql[@]}"; do
			ewarn "  ${EROOT}/usr/share/doc/${PF}/schema/<mysql|pgsql>/upgrades/${v}.sql*"
		done
		ewarn "See https://icinga.com/docs/icinga-db/latest/doc/04-Upgrading/"
	fi
}
