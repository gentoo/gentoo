# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit flag-o-matic lua-single

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="https://dnsdist.org"

SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="bpf cdb dnscrypt dnstap doh doh3 ipcipher lmdb quic regex snmp +ssl systemd test web xdp"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}
		dnscrypt? ( ssl )
		doh? ( ssl )
		doh3? ( ssl quic )
		ipcipher? ( ssl )
		quic? ( ssl )"

RDEPEND="acct-group/dnsdist
	acct-user/dnsdist
	bpf? ( dev-libs/libbpf:= )
	cdb? ( dev-db/tinycdb:= )
	dev-libs/boost:=
	sys-libs/libcap
	dev-libs/libedit
	dev-libs/libsodium:=
	dnstap? ( dev-libs/fstrm )
	doh? ( net-libs/nghttp2:= )
	doh3? ( net-libs/quiche:= )
	lmdb? ( dev-db/lmdb:= )
	quic? ( net-libs/quiche )
	regex? ( dev-libs/re2:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd:0= )
	xdp? ( net-libs/xdp-tools )
	${LUA_DEPS}
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# clean up duplicate file
	rm -f README.md
}

src_configure() {
	# bug #822855
	append-lfs-flags

	# some things can only be enabled/disabled by defines
	! use dnstap && append-cppflags -DDISABLE_PROTOBUF
	! use web && append-cppflags -DDISABLE_BUILTIN_HTML

	sed 's/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl$libdir'\''/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl\/$libdir'\''/g' \
		-i "${S}/configure"

	local myeconfargs=(
		--sysconfdir=/etc/dnsdist
		--with-lua="${ELUA}"
		--without-h2o
		--enable-tls-providers
		--without-gnutls
		$(use_with bpf ebpf)
		$(use_with cdb cdb)
		$(use_enable doh dns-over-https)
		$(use_enable doh3 dns-over-http3)
		$(use_enable dnscrypt)
		$(use_enable dnstap)
		$(use_enable ipcipher)
		$(use_with lmdb )
		$(use_enable quic dns-over-quic)
		$(use_with regex re2)
		$(use_with snmp net-snmp)
		$(use_enable ssl dns-over-tls)
		$(use_enable systemd) \
		$(use_enable test unit-tests)
		$(use_with xdp xsk)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc/dnsdist
	doins "${FILESDIR}"/dnsdist.conf.example

	newconfd "${FILESDIR}"/dnsdist.confd ${PN}
	newinitd "${FILESDIR}"/dnsdist.initd ${PN}
}

pkg_postinst() {
	elog "dnsdist provides multiple instances support. You can create more instances"
	elog "by symlinking the dnsdist init script to another name."
	elog
	elog "The name must be in the format dnsdist.<suffix> and dnsdist will use the"
	elog "/etc/dnsdist/dnsdist-<suffix>.conf configuration file instead of the default."
}
