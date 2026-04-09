# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson systemd

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/openconnect/ocserv.git"
else
	inherit verify-sig
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ocserv.asc"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ocserv )"
	SRC_URI="https://www.infradead.org/ocserv/download/${P}.tar.xz
		verify-sig? ( https://www.infradead.org/ocserv/download/${P}.tar.xz.sig )"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Openconnect SSL VPN server"
HOMEPAGE="https://ocserv.gitlab.io/www/index.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="geoip kerberos +lz4 +nftables otp pam radius +seccomp systemd tcpd root-tests test"
RESTRICT="!test? ( test ) root-tests? ( test )"
PROPERTIES="root-tests? ( test_privileged )"

DEPEND="
	dev-libs/libnl:3=
	dev-libs/libev:0=
	>=dev-libs/nettle-2.7:0=
	dev-libs/pcl:0=
	dev-libs/protobuf-c:0=
	>=net-libs/gnutls-3.3.0:0=
	sys-libs/readline:0=
	sys-libs/talloc:0=
	virtual/libcrypt:=
	geoip? ( dev-libs/geoip:0= )
	kerberos? ( app-crypt/mit-krb5 )
	lz4? ( app-arch/lz4:0= )
	otp? ( sys-auth/oath-toolkit:0= )
	pam? ( sys-libs/pam:0= )
	radius? ( net-libs/radcli:0= )
	seccomp? ( sys-libs/libseccomp:0= )
	systemd? ( sys-apps/systemd:0= )
	tcpd? ( sys-apps/tcp-wrappers:0= )
"
RDEPEND="${DEPEND}
	sys-apps/which
	nftables? ( net-firewall/nftables )
	!nftables? ( net-firewall/iptables )
"
BDEPEND+="
	net-misc/ipcalc-ng
	virtual/pkgconfig
	test? (
		${RDEPEND}
		net-libs/gnutls[tools(+)]
		net-libs/socket_wrapper
		net-vpn/openconnect
		sys-libs/nss_wrapper
		sys-libs/uid_wrapper
		pam? ( sys-libs/pam_wrapper )
		root-tests? (
			net-analyzer/nmap[ncat(+)]
			net-misc/iperf
		)
	)
"

CONFIG_CHECK="~TUN ~UNIX_DIAG"

src_configure() {
	local emesonargs=(
		--auto-features=disabled
		$(meson_feature pam)
		$(meson_feature radius)
		$(meson_feature kerberos gssapi)
		$(meson_feature otp liboath)
		-Dlibnl=enabled
		$(meson_feature geoip)
		$(meson_feature lz4)
		$(meson_feature seccomp)
		$(meson_feature systemd)
		$(meson_feature tcpd libwrap)
		-Dlocal-pcl=false
		$(meson_use root-tests)
		-Dfirewall-script=$(usex nftables nftables iptables)
	)
	meson_src_configure
}

src_test() {
	if [[ ${LD_PRELOAD} == *libsandbox* ]]; then
		# https://bugs.gentoo.org/961961
		ewarn "Skipping tests: libsandbox in LD_PRELOAD"
		return
	fi
	meson_src_test
}

src_install() {
	meson_src_install

	dodoc doc/sample.{config,passwd}
	use otp && dodoc doc/sample.otp

	doinitd "${FILESDIR}"/ocserv

	if use systemd; then
		systemd_dounit doc/systemd/socket-activated/ocserv.{service,socket}
	else
		systemd_dounit doc/systemd/standalone/ocserv.service
	fi
}
