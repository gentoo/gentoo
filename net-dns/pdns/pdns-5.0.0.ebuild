# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
PYTHON_COMPAT=( python3_{10..13} )

inherit eapi9-ver lua-single python-any-r1

DESCRIPTION="The PowerDNS Daemon"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc geoip ldap lmdb lua-records mysql odbc postgres remote sodium sqlite systemd tools tinydns test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}
	dev-libs/openssl:=
	dev-libs/boost:=
	lmdb? ( >=dev-db/lmdb-0.9.29 )
	lua-records? ( >=net-misc/curl-7.21.3 )
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:= )
	ldap? ( >=net-nds/openldap-2.0.27-r4:= app-crypt/mit-krb5 )
	odbc? ( dev-db/unixODBC )
	sqlite? ( dev-db/sqlite:3 )
	geoip? ( >=dev-cpp/yaml-cpp-0.5.1:= dev-libs/geoip )
	sodium? ( dev-libs/libsodium:= )
	tinydns? ( >=dev-db/tinycdb-0.77 )
	elibc_glibc? ( x86? ( >=sys-libs/glibc-2.34 ) )"
RDEPEND="${DEPEND}
	acct-user/pdns
	acct-group/pdns"

BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )"

S="${WORKDIR}"/${P/_/-}

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local cnf_dynmodules="bind lua2 pipe" # the default backends, always enabled

	use geoip && cnf_dynmodules+=" geoip"
	use ldap && cnf_dynmodules+=" ldap"
	use lmdb && cnf_dynmodules+=" lmdb"
	use mysql && cnf_dynmodules+=" gmysql"
	use odbc && cnf_dynmodules+=" godbc"
	use postgres && cnf_dynmodules+=" gpgsql"
	use remote && cnf_dynmodules+=" remote"
	use sqlite && cnf_dynmodules+=" gsqlite3"
	use tinydns && cnf_dynmodules+=" tinydns"

	econf \
		--enable-experimental-64bit-time_t-support-on-glibc \
		--disable-static \
		--sysconfdir=/etc/powerdns \
		--libdir=/usr/$(get_libdir)/powerdns \
		--with-service-user=pdns \
		--with-service-group=pdns \
		--with-modules= \
		--with-dynmodules="${cnf_dynmodules}" \
		--with-mysql-lib=/usr/$(get_libdir) \
		--with-lua="${ELUA}" \
		$(use_enable debug verbose-logging) \
		$(use_enable lua-records) \
		$(use_enable test unit-tests) \
		$(use_enable tools) \
		$(use_enable systemd) \
		$(use_with sodium libsodium) \
		${myconf}
}

src_compile() {
	default
	use doc && emake -C codedocs codedocs
}

src_install() {
	default

	mv "${D}"/etc/powerdns/pdns.conf{-dist,}

	fperms 0700 /etc/powerdns
	fperms 0600 /etc/powerdns/pdns.conf

	# set defaults: setuid=pdns, setgid=pdns
	sed -i \
		-e 's/^# set\([ug]\)id=$/set\1id=pdns/g' \
		"${D}"/etc/powerdns/pdns.conf

	newinitd "${FILESDIR}"/pdns-r1 pdns

	keepdir /var/empty

	if use doc; then
		docinto html
		dodoc -r codedocs/html/.
	fi

	# Install development headers
	insinto /usr/include/pdns
	doins pdns/*.hh
	insinto /usr/include/pdns/backends/gsql
	doins pdns/backends/gsql/*.hh

	if use ldap ; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/dnsdomain2.schema
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "PowerDNS provides multiple instances support. You can create more instances"
	elog "by symlinking the pdns init script to another name."
	elog
	elog "The name must be in the format pdns.<suffix> and PowerDNS will use the"
	elog "/etc/powerdns/pdns-<suffix>.conf configuration file instead of the default."
}
