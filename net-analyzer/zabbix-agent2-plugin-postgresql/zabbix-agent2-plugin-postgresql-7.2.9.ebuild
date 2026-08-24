# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A native Zabbix solution for monitoring PostgreSQL"
HOMEPAGE="https://www.zabbix.com/integrations/postgresql#postgresql_agent2"
SRC_URI="https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND=">=dev-lang/go-1.23"

PATCHES=(
	"${FILESDIR}/zabbix-agent2-plugin-postgresql-7.2.9-set-plugin-system-path.patch"
)

src_install() {
	insinto /etc/zabbix/zabbix_agent2.d/plugins.d/
	doins postgresql.conf
	exeinto /usr/libexec/zabbix-agent2/
	doexe zabbix-agent2-plugin-postgresql
	dodoc ChangeLog README.md
}
