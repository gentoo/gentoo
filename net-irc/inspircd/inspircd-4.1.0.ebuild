# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="Inspire IRCd - The Stable, High-Performance Modular IRCd"
HOMEPAGE="https://www.inspircd.org/"
SRC_URI="
	https://github.com/inspircd/inspircd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/clinew/gentoo-distfiles/raw/master/inspircd-${PV}-fix-build-paths.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="argon2 debug gnutls ldap log-json maxminddb mysql pcre2 postgres re2 regex-posix sqlite ssl sslrehashsignal syslog"

RDEPEND="
	acct-group/inspircd
	acct-user/inspircd
	dev-lang/perl
	argon2? ( app-crypt/argon2 )
	gnutls? ( net-libs/gnutls:= dev-libs/libgcrypt:0 )
	ldap? ( net-nds/openldap:= )
	log-json? ( dev-libs/rapidjson )
	maxminddb? ( dev-libs/libmaxminddb:= )
	mysql? ( dev-db/mysql-connector-c:= )
	pcre2? ( dev-libs/libpcre2 )
	postgres? ( dev-db/postgresql:= )
	re2? ( dev-libs/re2:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}"

DOC_CONTENTS="
	You will find example configuration files under /usr/share/doc/${PN}.\n
	Read the ${PN}.conf file carefully before starting the service."
DOCS=( docs/. .configure/apparmor )
PATCHES=( "${WORKDIR}"/${P}-fix-build-paths.patch )

src_configure() {
	local extras=""

	use argon2 && extras+="argon2,"
	use gnutls && extras+="ssl_gnutls,"
	use ldap && extras+="ldap,"
	use log-json && extras+="log_json,"
	use maxminddb && extras+="geo_maxmind,"
	use mysql && extras+="mysql,"
	use pcre2 && extras+="regex_pcre2,"
	use postgres && extras+="pgsql,"
	use re2 && extras+="regex_re2,"
	use regex-posix && extras+="regex_posix,"
	use sqlite && extras+="sqlite3,"
	use ssl && extras+="ssl_openssl,"
	use sslrehashsignal && extras+="sslrehashsignal,"
	use syslog && extras+="log_syslog,"

	# The first configuration run enables certain "extra" InspIRCd
	# modules, the second run generates the actual makefile.
	if [[ -n ${extras} ]]; then
		./configure --enable-extras=${extras%,} || die
	fi

	local myconf=(
		--disable-auto-extras
		--disable-ownership
		--system
		--uid ${PN}
		--gid ${PN}
		--binary-dir="/usr/bin"
		--data-dir="/var/lib/${PN}/data"
		--example-dir="/usr/share/doc/${PV}"
		--manual-dir="/usr/share/man"
		--module-dir="/usr/$(get_libdir)/${PN}/modules")
	CXX="$(tc-getCXX)" ./configure "${myconf[@]}" || die
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}" $(usev debug INSPIRCD_DEBUG=2) INSPIRCD_VERBOSE=1
}

src_install() {
	default

	insinto "/usr/include/${PN}"
	doins -r include/.

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit .configure/inspircd.service

	keepdir "/var/log/${PN}"
	insinto "/etc/logrotate.d"
	newins .configure/logrotate "${PN}"

	diropts -o"${PN}" -g"${PN}" -m0700
	keepdir "/var/lib/${PN}/data"

	readme.gentoo_create_doc

	rmdir "${ED}"/run{/inspircd,} || die
}

pkg_postinst() {
	readme.gentoo_print_elog
	if has_version "net-irc/atheme-services"; then
		ewarn "Atheme does not work with InspIRCd version 4"
		ewarn "See: https://github.com/atheme/atheme/issues/904"
	fi
}
