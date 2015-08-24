# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs user

DESCRIPTION="Inspire IRCd - The Stable, High-Performance Modular IRCd"
HOMEPAGE="https://inspircd.github.com/"
SRC_URI="https://www.github.com/inspircd/inspircd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="geoip gnutls ipv6 ldap mysql pcre posix postgres sqlite ssl tre"

RDEPEND="
	dev-lang/perl
	ssl? ( dev-libs/openssl )
	geoip? ( dev-libs/geoip )
	gnutls? ( net-libs/gnutls dev-libs/libgcrypt:0 )
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql[server] )
	pcre? ( dev-libs/libpcre )
	sqlite? ( >=dev-db/sqlite-3.0 )
	tre? ( dev-libs/tre )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	# Patch the inspircd launcher with the inspircd user
	sed -i -e "s/@UID@/${PN}/" "${S}/make/template/${PN}" || die

	epatch "${FILESDIR}/${P}-fix-path-builds.patch"
}

src_configure() {
	local extras=""
	local essl="--enable-openssl"
	local egnutls="--enable-gnutls"
	local dipv6="--disable-ipv6"

	use geoip && extras="${extras}m_geoip.cpp,"
	use gnutls && extras="${extras}m_ssl_gnutls.cpp,"
	use ipv6 && dipv6=""
	use ldap && extras="${extras}m_ldapauth.cpp,m_ldapoper.cpp,"
	use mysql && extras="${extras}m_mysql.cpp,"
	use pcre && extras="${extras}m_regex_pcre.cpp,"
	use posix && extras="${extras}m_regex_posix.cpp,"
	use postgres && extras="${extras}m_pgsql.cpp,"
	use sqlite && extras="${extras}m_sqlite3.cpp,"
	use ssl && extras="${extras}m_ssl_openssl.cpp,"
	use tre && extras="${extras}m_regex_tre.cpp,"

	use !ssl && essl=""
	use !gnutls && egnutls=""

	if [ -n "${extras}" ]; then
		./configure --disable-interactive --enable-extras=${extras}
	fi

	./configure \
		--with-cc="$(tc-getCXX)" \
		--disable-interactive \
		--prefix="/usr/$(get_libdir)/${PN}" \
		--config-dir="/etc/${PN}" \
		--data-dir="/var/lib/${PN}/data" \
		--log-dir="/var/log/${PN}" \
		--binary-dir="/usr/bin" \
		--module-dir="/usr/$(get_libdir)/${PN}/modules" \
		${essl} ${egnutls} ${dipv6} || die
}

src_compile() {
	emake V=1 LDFLAGS="${LDFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake INSTUID=${PN} \
		BINPATH="${D}/usr/bin" \
		BASE="${D}/usr/$(get_libdir)/${PN}/inspircd.launcher" \
		MODPATH="${D}/usr/$(get_libdir)/${PN}/modules/" \
		CONPATH="${D}/etc/${PN}" install

	insinto "/usr/include/${PN}"
	doins include/*

	diropts -o"${PN}" -g"${PN}" -m0700
	dodir "/var/lib/${PN}"
	dodir "/var/lib/${PN}/data"

	newinitd "${FILESDIR}/${P}-init" "${PN}"
	keepdir "/var/log/${PN}"/
}

pkg_postinst() {
	elog "Before starting ${PN} the first time, you should create"
	elog "the /etc/${PN}/${PN}.conf file."
	elog "You can find example configuration files under /etc/${PN}"
	elog "Read the ${PN}.conf.example file carefully before "
	elog "(re)starting the service."
	elog
}
