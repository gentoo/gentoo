# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Icinga configuration and state database supporting multiple environments"
HOMEPAGE="https://icinga.com/docs/icinga-db/"
SRC_URI="
	https://github.com/Icinga/icingadb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hydrapolic/gentoo-dist/releases/download/${P}/${P}-deps.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

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
