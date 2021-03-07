# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps systemd user

DESCRIPTION="Modern asynchronous DNS API"
HOMEPAGE="https://getdnsapi.net/"
SRC_URI="https://getdnsapi.net/releases/${P//./-}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +getdns-query +getdns-server-mon +idn libev libevent libressl libuv static-libs stubby +threads +unbound"

# https://bugs.gentoo.org/661760
# https://github.com/getdnsapi/getdns/issues/407
RESTRICT="test"

DEPEND="
	dev-libs/libbsd:=
	dev-libs/libyaml:=
	idn? ( net-dns/libidn2:= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	libev? ( dev-libs/libev:= )
	libevent? ( dev-libs/libevent:= )
	libuv? ( dev-libs/libuv:= )
	unbound? ( >=net-dns/unbound-1.4.16:= )
"
RDEPEND="
	${DEPEND}
	stubby? ( sys-libs/libcap:= )
"
BDEPEND="
	doc? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}/${PN}-1.4.2-stubby.service.patch" )

src_configure() {
	econf \
		--runstatedir=/var/run \
		$(use_enable static-libs static) \
		$(use_with getdns-query getdns_query) \
		$(use_with getdns-server-mon getdns_server_mon) \
		$(use_with idn libidn2) \
		$(use_with libev) \
		$(use_with libevent) \
		$(use_with libuv) \
		$(use_with stubby) \
		$(use_with threads libpthread) \
		$(use_with unbound libunbound) \
		--without-libidn \
		--with-piddir=/var/run/stubby
}

src_install() {
	default
	if use stubby; then
		newinitd "${FILESDIR}"/stubby.initd-r1 stubby
		newconfd "${FILESDIR}"/stubby.confd-r1 stubby
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/stubby.logrotate stubby
		systemd_dounit "${S}"/stubby/systemd/stubby.service
		systemd_dotmpfilesd "${S}"/stubby/systemd/stubby.conf
	fi
}

pkg_postinst() {
	if use stubby; then
		enewgroup stubby
		enewuser stubby -1 -1 -1 stubby
		fcaps cap_net_bind_service=ei /usr/bin/stubby
	fi

	if has_version '<dev-libs/libressl-2.7.0'; then
		ewarn "BEWARE: dev-libs/libressl prior to 2.7 does NOT check TLS certificates."
		if use stubby; then
			ewarn "You will NOT be able to use strict profile in Stubby."
		fi
	fi
}
