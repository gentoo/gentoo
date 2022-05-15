# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

if [[ ${PV} == 9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://gitlab.com/openconnect/ocserv.git"
else
	SRC_URI="ftp://ftp.infradead.org/pub/ocserv/${P}.tar.xz"
	KEYWORDS="amd64 arm ~arm64 ppc64 ~riscv x86"
fi

DESCRIPTION="Openconnect SSL VPN server"
HOMEPAGE="https://ocserv.gitlab.io/www/index.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="geoip kerberos +lz4 otp pam radius +seccomp systemd tcpd test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	test? (
		net-libs/gnutls[tools(+)]
		net-libs/socket_wrapper
		net-vpn/openconnect
		sys-libs/nss_wrapper
		sys-libs/uid_wrapper
		pam? ( sys-libs/pam_wrapper )
	)
"
DEPEND="
	dev-libs/libnl:3=
	dev-libs/libev:0=
	>=dev-libs/nettle-2.7:0=
	dev-libs/pcl:0=
	dev-libs/protobuf-c:0=
	>=net-libs/gnutls-3.3.0:0=
	net-libs/http-parser:0=
	sys-libs/readline:0=
	sys-libs/talloc:0=
	virtual/libcrypt:=
	geoip? ( dev-libs/geoip:0= )
	kerberos? ( virtual/krb5 )
	lz4? ( app-arch/lz4:0= )
	otp? ( sys-auth/oath-toolkit:0= )
	pam? ( sys-libs/pam:0= )
	radius? ( net-dialup/freeradius-client:0= )
	seccomp? ( sys-libs/libseccomp:0= )
	systemd? ( sys-apps/systemd:0= )
	tcpd? ( sys-apps/tcp-wrappers:0= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
}

src_configure() {
	local myconf=(
		--without-root-tests
		--without-nuttcp-tests

		$(use_enable seccomp)
		$(use_enable systemd)

		$(use_with geoip)
		$(use_with kerberos gssapi)
		$(use_with lz4)
		$(use_with otp liboath)
		$(use_with radius)
		$(use_with tcpd libwrap)
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	dodoc doc/sample.{config,passwd}
	use otp && dodoc doc/sample.otp

	doinitd "${FILESDIR}"/ocserv

	if use systemd; then
		systemd_dounit doc/systemd/socket-activated/ocserv.{service,socket}
	else
		systemd_dounit doc/systemd/standalone/ocserv.service
	fi
}
