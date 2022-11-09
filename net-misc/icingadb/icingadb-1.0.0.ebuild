# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Icinga configuration and state database supporting multiple environments"
HOMEPAGE="https://icinga.com/docs/icinga-db/"
SRC_URI="https://github.com/Icinga/icingadb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hydrapolic/gentoo-dist/raw/master/icinga/${P}-deps.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-user/icinga
	acct-group/icinga
"

DOCS=( config.example.yml doc README.md schema )

src_compile() {
	cd cmd/icingadb || die
	ego build
}

src_install() {
	dobin cmd/icingadb/icingadb
	einstalldocs

	newinitd "${FILESDIR}/icingadb.initd" "${PN}"

	keepdir /etc/icingadb
	keepdir /var/log/icingadb

	fperms 0750 /etc/icingadb /var/log/icingadb
	fowners icinga:icinga /etc/icingadb /var/log/icingadb
}
