# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Inspire IRCd - The Stable, High-Performance Modular IRCd"
HOMEPAGE="https://inspircd.github.com/"
SRC_URI="https://github.com/inspircd/inspircd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="debug gnutls ldap maxminddb mbedtls mysql pcre postgres re2 regex-posix regex-stdlib sqlite ssl sslrehashsignal tre"

RDEPEND="
	acct-group/inspircd
	acct-user/inspircd
	dev-lang/perl
	gnutls? ( net-libs/gnutls:= dev-libs/libgcrypt:0 )
	ldap? ( net-nds/openldap )
	maxminddb? ( dev-libs/libmaxminddb )
	mbedtls? ( net-libs/mbedtls:= )
	mysql? ( dev-db/mysql-connector-c:= )
	pcre? ( dev-libs/libpcre )
	postgres? ( dev-db/postgresql:= )
	re2? ( dev-libs/re2:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	ssl? ( dev-libs/openssl:= )
	tre? ( dev-libs/tre )"
DEPEND="${RDEPEND}"

DOCS=( docs/. )
PATCHES=( "${FILESDIR}"/${PN}-3.4.0-fix-path-builds.patch )

src_prepare() {
	default

	# Patch the inspircd launcher with the inspircd user
	sed -i -e "s/@UID@/${PN}/" "make/template/${PN}" || die
}

src_configure() {
	local extras=""

	use gnutls && extras+="m_ssl_gnutls.cpp,"
	use ldap && extras+="m_ldap.cpp,"
	use maxminddb && extras+="m_geo_maxmind.cpp,"
	use mbedtls && extras+="m_ssl_mbedtls.cpp,"
	use mysql && extras+="m_mysql.cpp,"
	use pcre && extras+="m_regex_pcre.cpp,"
	use postgres && extras+="m_pgsql.cpp,"
	use re2 && extras+="m_regex_re2.cpp,"
	use regex-posix && extras+="m_regex_posix.cpp,"
	use regex-stdlib && extras+="m_regex_stdlib.cpp,"
	use sqlite && extras+="m_sqlite3.cpp,"
	use ssl && extras+="m_ssl_openssl.cpp,"
	use sslrehashsignal && extras+="m_sslrehashsignal.cpp,"
	use tre && extras+="m_regex_tre.cpp,"

	# The first configuration run enables certain "extra" InspIRCd
	# modules, the second run generates the actual makefile.
	if [[ -n "${extras}" ]]; then
		./configure --disable-interactive --enable-extras=${extras%,}
	fi

	local myconf=(
		--disable-interactive
		--disable-auto-extras
		--prefix="/usr/$(get_libdir)/${PN}"
		--config-dir="/etc/${PN}"
		--data-dir="/var/lib/${PN}/data"
		--log-dir="/var/log/${PN}"
		--binary-dir="/usr/bin"
		--module-dir="/usr/$(get_libdir)/${PN}/modules"
		--manual-dir="/usr/share/man")
	CXX="$(tc-getCXX)" ./configure "${myconf[@]}"
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}" $(usex debug 'INSPIRCD_DEBUG=2' '') INSPIRCD_VERBOSE=1
}

src_install() {
	default

	insinto "/usr/include/${PN}"
	doins -r include/.

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "/var/log/${PN}"

	diropts -o"${PN}" -g"${PN}" -m0700
	keepdir "/var/lib/${PN}/data"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "You will find example configuration files under "
		elog "/usr/share/doc/${PN}"
		elog "Read the ${PN}.conf.example file carefully before "
		elog "starting the service."
	fi
	local pv
	for pv in ${REPLACING_VERSIONS}; do
		if ver_test "${pv}" -lt "2.0.24-r1"; then
			elog "Starting with 2.0.24-r1 the daemon is no longer started"
			elog "with the --logfile option and you are thus expected to define"
			elog "logging in the InspIRCd configuration file if you want it."
		fi
		if ver_test "${pv}" -lt "3.0.0"; then
			elog "Version 3.0 is a major upgrade which contains breaking"
			elog "changes.  You will need to update your configuration files."
			elog "See: https://docs.inspircd.org/3/configuration-changes"
		fi
	done
}
