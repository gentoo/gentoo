# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

LUA_COMPAT=( lua5-{1..4} luajit )

RUST_MIN_VER="1.82"
CRATES="
	anstyle@1.0.13
	atomic-waker@1.1.2
	base64@0.22.1
	bytes@1.11.1
	cc@1.2.49
	cfg-if@1.0.4
	clap@4.5.53
	clap_builder@4.5.53
	clap_lex@0.7.6
	codespan-reporting@0.13.1
	cxx@1.0.191
	cxx-build@1.0.191
	cxxbridge-cmd@1.0.191
	cxxbridge-flags@1.0.191
	cxxbridge-macro@1.0.191
	equivalent@1.0.2
	find-msvc-tools@0.1.5
	foldhash@0.2.0
	form_urlencoded@1.2.2
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	getrandom@0.2.16
	hashbrown@0.16.1
	http@1.4.0
	http-body@1.0.1
	http-body-util@0.1.3
	httparse@1.10.1
	httpdate@1.0.3
	hyper@1.8.1
	hyper-rustls@0.27.7
	hyper-util@0.1.19
	indexmap@2.12.1
	ipnet@2.11.0
	itoa@1.0.15
	libc@0.2.178
	link-cplusplus@1.0.12
	mio@1.1.1
	once_cell@1.21.3
	percent-encoding@2.3.2
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	proc-macro2@1.0.103
	quote@1.0.42
	ring@0.17.14
	rustls@0.23.35
	rustls-pki-types@1.13.1
	rustls-webpki@0.103.8
	ryu@1.0.20
	scratch@1.0.9
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_yaml@0.9.34+deprecated
	shlex@1.3.0
	smallvec@1.15.1
	socket2@0.6.1
	strsim@0.11.1
	subtle@2.6.1
	syn@2.0.111
	termcolor@1.4.1
	tokio@1.48.0
	tokio-rustls@0.26.4
	tower-service@0.3.3
	tracing@0.1.43
	tracing-core@0.1.35
	try-lock@0.2.5
	unicode-ident@1.0.22
	unicode-width@0.2.2
	unsafe-libyaml@0.2.11
	untrusted@0.9.0
	want@0.3.1
	wasi@0.11.1+wasi-snapshot-preview1
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.52.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	zeroize@1.8.2
"

inherit cargo flag-o-matic lua-single

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.xz ${CARGO_CRATE_URIS}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
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

	# rename .yml to .conf to facilitate easy upgrade and switch to .yml
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
