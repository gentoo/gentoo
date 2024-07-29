# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

LUA_COMPAT=( lua5-{1..4} luajit )

CRATES="
	cc@1.0.84
	codespan-reporting@0.11.1
	cxx-build@1.0.110
	cxx@1.0.110
	cxxbridge-flags@1.0.110
	cxxbridge-macro@1.0.110
	equivalent@1.0.1
	hashbrown@0.14.2
	indexmap@2.1.0
	ipnet@2.9.0
	itoa@1.0.9
	libc@0.2.150
	link-cplusplus@1.0.9
	once_cell@1.18.0
	proc-macro2@1.0.69
	quote@1.0.33
	ryu@1.0.15
	scratch@1.0.7
	serde@1.0.192
	serde_derive@1.0.192
	serde_yaml@0.9.27
	syn@2.0.39
	termcolor@1.4.0
	unicode-ident@1.0.12
	unicode-width@0.1.11
	unsafe-libyaml@0.2.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
"

inherit cargo flag-o-matic lua-single

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.bz2 ${CARGO_CRATE_URIS}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug dnstap snmp sodium systemd test valgrind"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}
	dnstap? ( dev-libs/fstrm )
	systemd? ( sys-apps/systemd:0= )
	snmp? ( net-analyzer/net-snmp )
	sodium? ( dev-libs/libsodium:= )
	elibc_glibc? (
		arm? ( >=sys-libs/glibc-2.34 )
		x86? ( >=sys-libs/glibc-2.34 )
	)
	dev-libs/openssl:=
	dev-libs/boost:=[context]"
RDEPEND="${DEPEND}
	!<net-dns/pdns-2.9.20-r1
	acct-user/pdns
	acct-group/pdns"
DEPEND="${DEPEND}
	valgrind? ( dev-debug/valgrind )"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${P/_/-}

pkg_setup() {
	lua-single_pkg_setup
	filter-flags -ftree-vectorize
	append-lfs-flags
	append-cppflags -D_TIME_BITS=64
}

src_configure() {
	econf \
		--sysconfdir=/etc/powerdns \
		--with-nod-cache-dir=/var/lib/powerdns \
		--with-service-user=pdns \
		--with-service-group=pdns \
		--with-lua="${ELUA}" \
		$(use_enable debug verbose-logging) \
		$(use_enable systemd) \
		$(use_enable dnstap dnstap) \
		$(use_enable test unit-tests) \
		$(use_enable valgrind) \
		$(use_with sodium libsodium) \
		$(use_with snmp net-snmp)
}

src_compile() {
	default
}

src_install() {
	default

	mv "${D}"/etc/powerdns/recursor.conf{-dist,}

	# set defaults: setuid=nobody, setgid=nobody
	sed -i \
		-e 's/^# set\([ug]\)id=$/set\1id=pdns/' \
		-e 's/^# quiet=$/quiet=on/' \
		-e 's/^# chroot=$/chroot=\/var\/lib\/powerdns/' \
		"${D}"/etc/powerdns/recursor.conf

	newinitd "${FILESDIR}"/pdns-recursor-r2 pdns-recursor
}

src_test() {
	default
}

pkg_postinst() {
	local old

	for old in ${REPLACING_VERSIONS}; do
		ver_test ${old} -lt 4.0.0-r1 || continue

		ewarn "Starting with 4.0.0-r1 the init script has been renamed from precursor"
		ewarn "to pdns-recursor, please update your runlevels accordingly."

		break
	done
}
