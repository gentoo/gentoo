# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

_SRCURI_P="${P/%_beta1/-beta.1}"

inherit cmake dot-a fcaps systemd tmpfiles

DESCRIPTION="Modern asynchronous DNS API"
HOMEPAGE="https://getdnsapi.net/"
SRC_URI="https://getdnsapi.net/releases/${_SRCURI_P//./-}/${_SRCURI_P}.tar.gz"
S="${WORKDIR}/${_SRCURI_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +getdns-query +getdns-server-mon gnutls +idn libev libevent libuv minimal static-libs stubby test +unbound"

# https://bugs.gentoo.org/661760
# https://github.com/getdnsapi/getdns/issues/407
# (As of 1.7.0, seems to need network)
RESTRICT="test"
#RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/openssl:=
	elibc_musl? ( dev-libs/libbsd )
	gnutls? (
		dev-libs/nettle:0=
		net-libs/gnutls:0=[dane,openssl]
	)
	idn? ( net-dns/libidn2:= )
	libev? ( dev-libs/libev )
	libevent? ( dev-libs/libevent:= )
	libuv? ( dev-libs/libuv:= )
	!minimal? ( >=net-dns/unbound-1.5.9:= )
	stubby? ( dev-libs/libyaml )
"
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-libs/check )
"
RDEPEND="
	${COMMON_DEPEND}
	stubby? (
		acct-group/stubby
		acct-user/stubby
	)
"
BDEPEND="doc? ( app-text/doxygen )"
IDEPEND="stubby? ( sys-libs/libcap )"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.2-stubby.service.patch"
	"${FILESDIR}/${PN}-1.7.3-cmake-linking.patch"
	"${FILESDIR}/${PN}-1.7.3-openssl-4.patch"
	"${FILESDIR}/${PN}-1.7.3-cmake_min.patch"
	"${FILESDIR}/stubby-0.4.3-install-dir.patch"
)

src_configure() {
	use static-libs && lto-guarantee-fat
	local mycmakeargs=(
		-DCMAKE_INSTALL_RUNSTATEDIR=/var/run/stubby
		-DBUILD_DOXYGEN=$(usex doc)
		-DBUILD_GETDNS_QUERY=$(usex getdns-query)
		-DBUILD_GETDNS_SERVER_MON=$(usex getdns-server-mon)
		-DBUILD_STUBBY=$(usex stubby)
		-DENABLE_STATIC=$(usex static-libs)
		-DBUILD_TESTING:BOOL=$(usex test)
		-DENABLE_UNBOUND_EVENT_API=$(usex unbound)
		-DENABLE_STUB_ONLY=$(usex minimal)
		-DUSE_GNUTLS=$(usex gnutls)
		-DBUILD_LIBEV=$(usex libev)
		-DBUILD_LIBEVENT2=$(usex libevent)
		-DUSE_LIBIDN2=$(usex idn)
		-DBUILD_LIBUV=$(usex libuv)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use stubby; then
		newinitd "${FILESDIR}"/stubby.initd-r3 stubby
		newconfd "${FILESDIR}"/stubby.confd-r1 stubby
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/stubby.logrotate stubby
		systemd_dounit "${S}"/stubby/systemd/stubby.service
		dotmpfiles "${S}"/stubby/systemd/stubby.conf
	fi
	use static-libs && strip-lto-bytecode
}

pkg_postinst() {
	if use stubby; then
		fcaps cap_net_bind_service=ei usr/bin/stubby
		tmpfiles_process stubby.conf
	fi
}
