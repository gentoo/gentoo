# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Inspire IRCd - The Stable, High-Performance Modular IRCd"
HOMEPAGE="https://www.inspircd.org/"
SRC_URI="
	https://github.com/inspircd/inspircd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/clinew/gentoo-distfiles/raw/master/inspircd-${PV}-fix-build-paths.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="debug gnutls ldap maxminddb mbedtls mysql pcre postgres re2 regex-posix regex-stdlib sqlite ssl sslrehashsignal tre"

RDEPEND="
	acct-group/inspircd
	acct-user/inspircd
	dev-lang/perl
	gnutls? ( net-libs/gnutls:= dev-libs/libgcrypt:0 )
	ldap? ( net-nds/openldap:= )
	maxminddb? ( dev-libs/libmaxminddb:= )
	mbedtls? ( net-libs/mbedtls:= )
	mysql? ( dev-db/mysql-connector-c:= )
	pcre? ( dev-libs/libpcre )
	postgres? ( dev-db/postgresql:= )
	re2? ( dev-libs/re2:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	ssl? ( dev-libs/openssl:= )
	tre? ( dev-libs/tre )"
DEPEND="${RDEPEND}"

DOCS=( docs/. .configure/apparmor )
PATCHES=( "${WORKDIR}"/${P}-fix-build-paths.patch )

src_configure() {
	local extras=""

	use gnutls && extras+="ssl_gnutls,"
	use ldap && extras+="ldap,"
	use maxminddb && extras+="geo_maxmind,"
	use mbedtls && extras+="ssl_mbedtls,"
	use mysql && extras+="mysql,"
	use pcre && extras+="regex_pcre,"
	use postgres && extras+="pgsql,"
	use re2 && extras+="regex_re2,"
	use regex-posix && extras+="regex_posix,"
	use regex-stdlib && extras+="regex_stdlib,"
	use sqlite && extras+="sqlite3,"
	use ssl && extras+="ssl_openssl,"
	use sslrehashsignal && extras+="sslrehashsignal,"
	use tre && extras+="regex_tre,"

	# The first configuration run enables certain "extra" InspIRCd
	# modules, the second run generates the actual makefile.
	if [[ -n "${extras}" ]]; then
		./configure --enable-extras=${extras%,}
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
	CXX="$(tc-getCXX)" ./configure "${myconf[@]}"
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

	rmdir "${ED}"/run{/inspircd,} || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "You will find example configuration files under "
		elog "/usr/share/doc/${PN}"
		elog "Read the ${PN}.conf.example file carefully before "
		elog "starting the service."
	fi
}
