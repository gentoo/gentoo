# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Open Source Host-based Intrusion Detection System"
HOMEPAGE="https://www.ossec.net/"
SRC_URI="https://github.com/ossec/ossec-hids/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="agent hybrid local mysql postgres server sqlite"
REQUIRED_USE="^^ ( agent hybrid local server )
	?? ( mysql postgres )"

DEPEND="mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite:3 )
	postgres? ( dev-db/postgresql:= )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}/src"
PATCHES=( "${FILESDIR}/makefile-${PV}.patch" )

declare -a MY_OPT

pkg_setup() {
	enewuser ossec -1 -1 /var/ossec
	enewuser ossecm -1 -1 -1 ossec
	enewuser ossecr -1 -1 -1 ossec
}

src_configure() {
	local target="local"
	use agent && target="agent"
	use hybrid && target="hybrid"
	use server && target="server"
	MY_OPT=(
		TARGET=${target}
		USE_SQLITE=$(usex sqlite)
		V=0
		ZLIB_SYSTEM=yes
	)
	use mysql && MY_OPT+=( DATABASE=mysql )
	use postgres && MY_OPT+=( DATABASE=pgsql )
}

src_compile() {
	emake "${MY_OPT[@]}" PREFIX=/var/ossec
}

src_test() {
	emake "${MY_OPT[@]}" PREFIX=/var/ossec test
}

src_install() {
	keepdir /var/ossec/logs/{alerts,archives,firewall}
	keepdir /var/ossec/lua/{compiled,native}
	keepdir /var/ossec/queue/{agent-info,agentless,alerts,diff,fts,ossec,rids,rootcheck,syscheck}
	keepdir /var/ossec/{.ssh,stats,tmp,var/run}
	newenvd - 50ossec-hids <<<'CONFIG_PROTECT="/var/ossec/etc"'
	emake "${MY_OPT[@]}" PREFIX="${D}/var/ossec" install
}
