# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

LUA_COMPAT=( lua5-{1..4} luajit )

CRATES="
	base64@0.21.7
	cc@1.0.98
	codespan-reporting@0.11.1
	cxx-build@1.0.122
	cxx@1.0.122
	cxxbridge-flags@1.0.122
	cxxbridge-macro@1.0.122
	equivalent@1.0.1
	hashbrown@0.14.5
	indexmap@2.2.6
	ipnet@2.9.0
	itoa@1.0.11
	link-cplusplus@1.0.9
	once_cell@1.19.0
	proc-macro2@1.0.84
	quote@1.0.36
	ryu@1.0.18
	scratch@1.0.7
	serde@1.0.203
	serde_derive@1.0.203
	serde_yaml@0.9.34+deprecated
	syn@2.0.66
	termcolor@1.4.1
	unicode-ident@1.0.12
	unicode-width@0.1.12
	unsafe-libyaml@0.2.11
	winapi-util@0.1.8
	windows-sys@0.52.0
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
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

	# rename .yml file to .conf, to facilitate easy upgrade and switch to .yml
	mv "${D}"/etc/powerdns/recursor.{yml-dist,conf} || die

	sed -i \
		-e 's/^#   set\([ug]\)id: '\'\''$/    set\1id: '\''pdns'\''/' \
		-e 's/^#   chroot: '\'\''$/    chroot: '\''\/var\/lib\/powerdns'\''/' \
		"${D}"/etc/powerdns/recursor.conf || die

	newinitd "${FILESDIR}"/pdns-recursor-r3 pdns-recursor

	keepdir /var/lib/powerdns
}

src_test() {
	default
}

pkg_postinst() {
	einfo "Starting with 5.1.x we default to using the new yaml configuration file format."
	einfo "The old configuration file format is still supported for now, but please update"
	einfo "your recursor.conf to yaml using 'rec_control show-yaml'."
}
