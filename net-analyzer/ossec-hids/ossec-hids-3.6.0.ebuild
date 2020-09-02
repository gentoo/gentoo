# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Open Source Host-based Intrusion Detection System"
HOMEPAGE="https://www.ossec.net/"
SRC_URI="https://github.com/ossec/ossec-hids/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="agent hybrid local mysql postgres server sqlite test"
REQUIRED_USE="^^ ( agent hybrid local server )
	?? ( mysql postgres )"
RESTRICT="!test? ( test )"

RDEPEND="acct-user/ossec
	acct-user/ossecm
	acct-user/ossecr
	dev-libs/libevent
	dev-libs/libpcre2[jit]
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	test? (
		dev-libs/check
		dev-python/subunit
	)"
S="${WORKDIR}/${P}/src"

declare -a MY_OPT

src_prepare() {
	# Patch for the GCC version 10 -fno-common change. See
	# https://github.com/ossec/ossec-hids/pull/1875
	eapply -p2 "${FILESDIR}/gcc-fno-common-${PV}.patch"
	eapply -p1 "${FILESDIR}/makefile-${PV}.patch"
	eapply_user
}

src_configure() {
	local target="local"
	use agent && target="agent"
	use hybrid && target="hybrid"
	use server && target="server"
	MY_OPT=(
		PCRE2_SYSTEM=yes
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
