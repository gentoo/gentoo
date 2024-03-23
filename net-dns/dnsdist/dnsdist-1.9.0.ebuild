# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit flag-o-matic lua-single

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="https://dnsdist.org"

SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="dnscrypt dnstap doh doh3 gnutls ipcipher +lmdb quic regex remote-logging snmp +ssl systemd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}
		dnscrypt? ( ssl )
		gnutls? ( ssl )
		doh? ( ssl !gnutls )
		doh3? ( ssl !gnutls quic )
		ipcipher? ( ssl !gnutls )
		quic? ( ssl !gnutls )
		ssl? ( !gnutls )"

RDEPEND="acct-group/dnsdist
	acct-user/dnsdist
	dev-libs/boost:=
	dev-libs/libedit:=
	dev-libs/libsodium:=
	>=dev-libs/protobuf-3:=
	dnstap? ( dev-libs/fstrm:= )
	doh3? ( net-libs/quiche:= )
	lmdb? ( dev-db/lmdb:= )
	quic? ( net-libs/quiche:= )
	regex? ( dev-libs/re2:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
	systemd? ( sys-apps/systemd:0= )
	${LUA_DEPS}
	net-libs/nghttp2
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# bug #822855
	append-lfs-flags

	econf \
		--sysconfdir=/etc/dnsdist \
		--with-lua="${ELUA}" \
		--enable-tls-providers \
		--enable-asan \
		--enable-lsan \
		--enable-ubsan \
		$(use_enable doh dns-over-https) \
		$(use_enable doh3 dns-over-http3) \
		$(use_enable dnscrypt) \
		$(use_enable dnstap) \
		$(use_enable ipcipher) \
		$(use_with lmdb ) \
		$(use_enable quic dns-over-quic ) \
		$(use_with regex re2) \
		$(use_with snmp net-snmp) \
		$(use ssl && { echo "--enable-dns-over-tls" && use_with gnutls && use_with !gnutls libssl;} || echo "--without-gnutls --without-libssl") \
		$(use_enable systemd) \
		$(use_enable test unit-tests)
		sed 's/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl$libdir'\''/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl\/$libdir'\''/g' \
			-i "${S}/configure" || die
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
