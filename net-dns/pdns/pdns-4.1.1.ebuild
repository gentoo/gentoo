# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils multilib user toolchain-funcs versionator

DESCRIPTION="The PowerDNS Daemon"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# other possible flags:
# db2: we lack the dep
# oracle: dito (need Oracle Client Libraries)
# xdb: (almost) dead, surely not supported

IUSE="botan debug doc geoip ldap libressl lua luajit mydns mysql opendbx postgres protobuf remote sodium sqlite systemd tools tinydns test"

REQUIRED_USE="mydns? ( mysql ) ?? ( lua luajit )"

RDEPEND="
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:= )
	>=dev-libs/boost-1.35:=
	botan? ( dev-libs/botan:2= )
	lua? ( dev-lang/lua:= )
	luajit? ( dev-lang/luajit:= )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:= )
	ldap? ( >=net-nds/openldap-2.0.27-r4 app-crypt/mit-krb5 )
	sqlite? ( dev-db/sqlite:3 )
	opendbx? ( dev-db/opendbx )
	geoip? ( >=dev-cpp/yaml-cpp-0.5.1 dev-libs/geoip )
	sodium? ( dev-libs/libsodium:= )
	tinydns? ( >=dev-db/tinycdb-0.77 )
	protobuf? ( dev-libs/protobuf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}"/${P/_/-}

src_configure() {
	local dynmodules="pipe bind" # the default backends, always enabled

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

	econf \
		--disable-static \
		--sysconfdir=/etc/powerdns \
		--libdir=/usr/$(get_libdir)/powerdns \
		--with-modules= \
		--with-dynmodules="${dynmodules}" \
		--with-mysql-lib=/usr/$(get_libdir) \
		$(use_enable botan) \
		$(use_enable debug verbose-logging) \
		$(use_enable test unit-tests) \
		$(use_enable tools) \
		$(use_enable systemd) \
		$(use_enable sodium libsodium) \
		$(use_with lua) \
		$(use_with luajit) \
		$(use_with protobuf) \
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

	local old
	for old in ${REPLACING_VERSIONS}; do
		version_compare ${old} 3.2
		[[ $? -eq 1 ]] || continue

		ewarn "To fix a security bug (bug #458018) had the following"
		ewarn "files/directories the world-readable bit removed (if set):"
		ewarn "  ${EPREFIX}/etc/powerdns"
		ewarn "  ${EPREFIX}/etc/powerdns/pdns.conf"
		ewarn "Check if this is correct for your setup"
		ewarn "This is a one-time change and will not happen on subsequent updates."
		chmod o-rwx "${EPREFIX}"/etc/powerdns/{,pdns.conf}

		break
	done
}
