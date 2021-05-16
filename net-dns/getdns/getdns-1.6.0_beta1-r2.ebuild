# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_SRCURI_P="${P/%_beta1/-beta.1}"

inherit cmake fcaps systemd tmpfiles

DESCRIPTION="Modern asynchronous DNS API"
HOMEPAGE="https://getdnsapi.net/"
SRC_URI="https://getdnsapi.net/releases/${_SRCURI_P//./-}/${_SRCURI_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +getdns-query +getdns-server-mon gnutls +idn libev libevent libuv static-libs stubby +unbound"

S="${WORKDIR}/${_SRCURI_P}"

# https://bugs.gentoo.org/661760
# https://github.com/getdnsapi/getdns/issues/407
RESTRICT="test"

DEPEND="
	dev-libs/libbsd
	dev-libs/libyaml
	dev-libs/openssl:=
	idn? ( net-dns/libidn2:= )
	gnutls? (
		net-libs/gnutls:0=[dane,openssl]
		dev-libs/nettle:0=
	)
	libev? ( dev-libs/libev:= )
	libevent? ( dev-libs/libevent:= )
	libuv? ( dev-libs/libuv:= )
	>=net-dns/unbound-1.5.9:=
"
RDEPEND="
	${DEPEND}
	stubby? (
		acct-group/stubby
		acct-user/stubby
		sys-libs/libcap
	)
"
BDEPEND="
	doc? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}/${PN}-1.4.2-stubby.service.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_RUNSTATEDIR=/var/run
		-DBUILD_DOXYGEN=$(usex doc)
		-DBUILD_GETDNS_QUERY=$(usex getdns-query)
		-DBUILD_GETDNS_SERVER_MON=$(usex getdns-server-mon)
		-DBUILD_STUBBY=$(usex stubby)
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_UNBOUND_EVENT_API=$(usex unbound)
		-DUSE_GNUTLS=$(usex gnutls)
		-DUSE_LIBEV=$(usex libev)
		-DUSE_LIBEVENT2=$(usex libevent)
		-DUSE_LIBIDN2=$(usex idn)
		-DUSE_LIBUV=$(usex libuv)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use stubby; then
		newinitd "${FILESDIR}"/stubby.initd-r2 stubby
		newconfd "${FILESDIR}"/stubby.confd-r1 stubby
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/stubby.logrotate stubby
		systemd_dounit "${S}"/stubby/systemd/stubby.service
		dotmpfiles "${S}"/stubby/systemd/stubby.conf
	fi
}

pkg_postinst() {
	if use stubby; then
		fcaps cap_net_bind_service=ei /usr/bin/stubby
	fi
}
