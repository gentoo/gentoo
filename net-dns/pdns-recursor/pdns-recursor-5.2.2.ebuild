# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

LUA_COMPAT=( lua5-{1..4} luajit )

CRATES="
	anyhow@1.0.87
	base64@0.22.1
	cc@1.1.18
	codespan-reporting@0.11.1
	cxx-build@1.0.128
	cxx@1.0.128
	cxxbridge-flags@1.0.128
	cxxbridge-macro@1.0.128
	equivalent@1.0.1
	hashbrown@0.14.5
	indexmap@2.5.0
	ipnet@2.10.0
	itoa@1.0.11
	libyml@0.0.5
	link-cplusplus@1.0.9
	memchr@2.7.4
	once_cell@1.19.0
	proc-macro2@1.0.86
	quote@1.0.37
	ryu@1.0.18
	scratch@1.0.7
	serde@1.0.210
	serde_derive@1.0.210
	serde_yaml@0.9.34+deprecated
	shlex@1.3.0
	syn@2.0.77
	termcolor@1.4.1
	unicode-ident@1.0.12
	unicode-width@0.1.13
	unsafe-libyaml@0.2.11
	version_check@0.9.5
	winapi-util@0.1.9
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

inherit cargo flag-o-matic lua-single

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.bz2 ${CARGO_CRATE_URIS}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug dns-over-tls dnstap snmp sodium systemd test valgrind"
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
	>=dev-libs/boost-1.54:=[context]"
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
	filter-lto
	rust_pkg_setup
}

src_configure() {
	econf \
		--enable-experimental-64bit-time_t-support-on-glibc \
		--sysconfdir=/etc/powerdns \
		--with-nod-cache-dir=/var/lib/powerdns \
		--with-service-user=pdns \
		--with-service-group=pdns \
		--with-lua="${ELUA}" \
		$(use_enable debug verbose-logging) \
		$(use_enable systemd) \
		$(use_enable dns-over-tls) \
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
