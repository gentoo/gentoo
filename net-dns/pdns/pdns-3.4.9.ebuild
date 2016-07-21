# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib systemd user toolchain-funcs versionator

DESCRIPTION="The PowerDNS Daemon"
HOMEPAGE="http://www.powerdns.com/"
SRC_URI="http://downloads.powerdns.com/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# other possible flags:
# db2: we lack the dep
# oracle: dito (need Oracle Client Libraries)
# xdb: (almost) dead, surely not supported

IUSE="botan cryptopp debug doc geoip ldap lua mydns mysql opendbx postgres remote sqlite static tools tinydns test"

REQUIRED_USE="mydns? ( mysql )"

RDEPEND="!static? (
		net-libs/polarssl
		>=dev-libs/boost-1.34:=
		botan? ( =dev-libs/botan-1.10* )
		cryptopp? ( dev-libs/crypto++ )
		lua? ( dev-lang/lua:= )
		mysql? ( virtual/mysql )
		postgres? ( dev-db/postgresql:= )
		ldap? ( >=net-nds/openldap-2.0.27-r4 )
		sqlite? ( dev-db/sqlite:3 )
		opendbx? ( dev-db/opendbx )
		geoip? ( >=dev-cpp/yaml-cpp-0.5.1 dev-libs/geoip )
		tinydns? ( >=dev-db/tinycdb-0.77 )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	static? (
		>=net-libs/polarssl-1.3.0[static-libs(+)]
		>=dev-libs/boost-1.34[static-libs(+)]
		botan? ( =dev-libs/botan-1.10*[static-libs(+)] )
		cryptopp? ( dev-libs/crypto++[static-libs(+)] )
		lua? ( dev-lang/lua:=[static-libs(+)] )
		mysql? ( virtual/mysql[static-libs(+)] )
		postgres? ( dev-db/postgresql[static-libs(+)] )
		ldap? ( >=net-nds/openldap-2.0.27-r4[static-libs(+)] )
		sqlite? ( dev-db/sqlite:3[static-libs(+)] )
		opendbx? ( dev-db/opendbx[static-libs(+)] )
		geoip? ( >=dev-cpp/yaml-cpp-0.5.1 dev-libs/geoip[static-libs(+)] )
		tinydns? ( >=dev-db/tinycdb-0.77 )
	)
	doc? ( app-doc/doxygen )"

src_configure() {
	local dynmodules="pipe geo bind" # the default backends, always enabled
	local modules=""

	#use db2 && dynmodules+=" db2"
	use ldap && dynmodules+=" ldap"
	use lua && dynmodules+=" lua"
	use mydns && dynmodules+=" mydns"
	use mysql && dynmodules+=" gmysql"
	use opendbx && dynmodules+=" opendbx"
	#use oracle && dynmodules+=" goracle oracle"
	use postgres && dynmodules+=" gpgsql"
	use remote && dynmodules+=" remote"
	use sqlite && dynmodules+=" gsqlite3"
	use tinydns && dynmodules+=" tinydns"
	use geoip && dynmodules+=" geoip"
	#use xdb && dynmodules+=" xdb"

	if use static ; then
		modules="${dynmodules}"
		dynmodules=""
	fi

	use botan && myconf+=" --enable-botan1.10"
	use cryptopp && myconf+=" --enable-cryptopp"
	use debug && myconf+=" --enable-verbose-logging"

	CRYPTOPP_CFLAGS=" " \
	CRYPTOPP_LIBS="-lcrypto++" \
	econf \
		--with-system-polarssl \
		--disable-static \
		--sysconfdir=/etc/powerdns \
		--libdir=/usr/$(get_libdir)/powerdns \
		--with-modules="${modules}" \
		--with-dynmodules="${dynmodules}" \
		--with-pgsql-includes=/usr/include \
		--with-pgsql-lib=/usr/$(get_libdir) \
		--with-mysql-lib=/usr/$(get_libdir) \
		$(use_enable test unit-tests) \
		$(use_with lua) \
		$(use_enable static static-binaries) \
		$(use_enable tools) \
		${myconf}
}

src_compile() {
	default
	use doc && emake -C codedocs codedocs
}

src_install () {
	default

	mv "${D}"/etc/powerdns/pdns.conf{-dist,}

	fperms 0700 /etc/powerdns
	fperms 0600 /etc/powerdns/pdns.conf

	# set defaults: setuid=pdns, setgid=pdns
	sed -i \
		-e 's/^# set\([ug]\)id=$/set\1id=pdns/g' \
		"${D}"/etc/powerdns/pdns.conf

	doinitd "${FILESDIR}"/pdns
	systemd_newunit contrib/systemd-pdns.service pdns.service

	keepdir /var/empty

	use doc && dohtml -r codedocs/html/.

	# Install development headers
	insinto /usr/include/pdns
	doins pdns/*.hh
	insinto /usr/include/pdns/backends/gsql
	doins pdns/backends/gsql/*.hh

	if use ldap ; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/dnsdomain2.schema
	fi

	prune_libtool_files --all
}

pkg_preinst() {
	enewgroup pdns
	enewuser pdns -1 -1 /var/empty pdns
}

pkg_postinst() {
	elog "PowerDNS provides multiple instances support. You can create more instances"
	elog "by symlinking the pdns init script to another name."
	elog
	elog "The name must be in the format pdns.<suffix> and PowerDNS will use the"
	elog "/etc/powerdns/pdns-<suffix>.conf configuration file instead of the default."

	if use ldap ; then
		ewarn "The official LDAP backend module is only compile-tested by upstream."
		ewarn "Try net-dns/pdns-ldap-backend if you have problems with it."
	fi

	local fix_perms=0

	for rv in ${REPLACING_VERSIONS} ; do
		version_compare ${rv} 3.2
		[[ $? -eq 1 ]] && fix_perms=1
	done

	if [[ $fix_perms -eq 1 ]] ; then
		ewarn "To fix a security bug (bug #458018) had the following"
		ewarn "files/directories the world-readable bit removed (if set):"
		ewarn "  ${EPREFIX}/etc/pdns"
		ewarn "  ${EPREFIX}/etc/pdns/pdns.conf"
		ewarn "Check if this is correct for your setup"
		ewarn "This is a one-time change and will not happen on subsequent updates."
		chmod o-rwx "${EPREFIX}"/etc/pdns/{,pdns.conf}
	fi

}
