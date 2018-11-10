# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user fcaps systemd

DESCRIPTION="Modern asynchronous DNS API"
HOMEPAGE="https://getdnsapi.net/"
SRC_URI="https://getdnsapi.net/releases/${P//./-}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="stubby +getdns_query +getdns_server_mon libressl +idn +unbound libevent libev libuv +threads static-libs"

# https://bugs.gentoo.org/661760
# https://github.com/getdnsapi/getdns/issues/407
RESTRICT="test"

DEPEND="
	dev-libs/libbsd:=
	dev-libs/libyaml:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	idn? ( net-dns/libidn2:= )
	unbound? ( >=net-dns/unbound-1.4.16:= )
	libevent? ( dev-libs/libevent:= )
	libev? ( dev-libs/libev:= )
	libuv? ( dev-libs/libuv:= )
"
RDEPEND="
	${DEPEND}
	stubby? ( sys-libs/libcap:= )
"

PATCHES=( "${FILESDIR}/${PN}-1.4.2-stubby.service.patch" )

src_configure() {
	econf \
		--runstatedir=/var/run \
		--with-piddir=/var/run/stubby \
		$(use_with stubby) \
		$(use_with getdns_query) \
		$(use_with getdns_server_mon) \
		$(use_with idn libidn2) \
		--without-libidn \
		$(use_with unbound libunbound) \
		$(use_with libevent) \
		$(use_with libev) \
		$(use_with libuv) \
		$(use_with threads libpthread) \
		$(use_enable static-libs static)
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

	if has_version <dev-libs/libressl-2.7.0; then
		ewarn "BEWARE: dev-libs/libressl prior to 2.7 does NOT check TLS certificates."
		if use stubby; then
			ewarn "You will NOT be able to use strict profile in Stubby."
		fi
	fi
}
