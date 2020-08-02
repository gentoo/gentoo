# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="https://dnsdist.org"

SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="dnscrypt dnstap doh gnutls +lmdb luajit regex remote-logging snmp +ssl systemd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="dnscrypt? ( ssl )
		gnutls? ( ssl )
		doh? ( ssl !gnutls )"

RDEPEND="acct-group/dnsdist
	acct-user/dnsdist
	>=dev-libs/boost-1.35:=
	dev-libs/libedit:=
	dnscrypt? ( dev-libs/libsodium:= )
	dnstap? ( dev-libs/fstrm:= )
	doh? ( www-servers/h2o:=[libh2o] )
	lmdb? ( dev-db/lmdb:= )
	luajit? ( dev-lang/luajit:= )
	!luajit? ( >=dev-lang/lua-5.1:= )
	regex? ( dev-libs/re2:= )
	remote-logging? ( >=dev-libs/protobuf-3:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
	systemd? ( sys-apps/systemd:0= )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
}

src_configure() {
	econf \
		--sysconfdir=/etc/dnsdist \
		$(use_enable doh dns-over-https) \
		$(use_enable dnscrypt) \
		$(use_enable dnstap) \
		$(use_with lmdb ) \
		$(use luajit && echo "--with-lua=luajit" || echo "--with-lua=lua" ) \
		$(use_with regex re2) \
		$(use_with remote-logging protobuf) \
		$(use_with snmp net-snmp) \
		$(use ssl && { echo "--enable-dns-over-tls" && use_with gnutls && use_with !gnutls libssl;} || echo "--without-gnutls --without-libssl") \
		$(use_enable systemd) \
		$(use_enable test unit-tests)
		sed 's/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl$libdir'\''/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl\/$libdir'\''/g' \
			-i "${S}/configure"
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
