# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit branding pam systemd verify-sig

DESCRIPTION="Collection of common network programs"
HOMEPAGE="https://www.gnu.org/software/inetutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

SERVERS="ftpd inetd rexecd rlogind rshd syslogd talkd telnetd tftpd uucpd"
CLIENTS="ftp dnsdomainname hostname ping ping6 rcp rexec rlogin rsh logger telnet tftp whois ifconfig traceroute"
PROGRAMS="${SERVERS} ${CLIENTS}"
IUSE="idn kerberos pam tcpd ${PROGRAMS}"

DEPEND="
	sys-libs/readline:0=
	ftpd? ( virtual/libcrypt:0= )
	idn? ( net-dns/libidn2:= )
	kerberos? ( virtual/krb5 )
	pam? ( sys-libs/pam )
	tcpd? ( sys-apps/tcp-wrappers )
	uucpd? ( virtual/libcrypt:0= )
"
RDEPEND="${DEPEND}
	ftpd? ( net-ftp/ftpbase[pam?] )
	ftp? ( !net-ftp/ftp )
	dnsdomainname? ( !sys-apps/net-tools )
	hostname? ( !sys-apps/coreutils[hostname(-)] !sys-apps/net-tools[hostname(+)] )
	inetd? ( !sys-apps/netkit-base )
	ping? ( !net-misc/iputils )
	ping6? ( !net-misc/iputils[ipv6(+)] )
	rcp? ( !net-misc/netkit-rsh )
	rexec? ( !net-misc/netkit-rsh )
	rexecd? ( !net-misc/netkit-rsh )
	rlogin? ( !net-misc/netkit-rsh )
	rlogind? ( !net-misc/netkit-rsh )
	rsh? ( !net-misc/netkit-rsh )
	rshd? ( !net-misc/netkit-rsh )
	logger? ( !sys-apps/util-linux[logger(+)] )
	syslogd? ( !app-admin/sysklogd )
	talkd? ( !net-misc/netkit-talk )
	telnet? ( !net-misc/telnet-bsd !net-misc/netkit-telnetd )
	telnetd? ( !net-misc/telnet-bsd !net-misc/netkit-telnetd )
	tftp? ( !net-ftp/tftp-hpa[client(+)] )
	tftpd? ( !net-ftp/tftp-hpa[server(+)] )
	whois? ( !net-misc/whois )
	ifconfig? ( !sys-apps/net-tools )
	traceroute? ( !net-analyzer/traceroute )
"
BDEPEND="
	sec-keys/openpgp-keys-inetutils
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/inetutils.asc"

QA_CONFIG_IMPL_DECL_SKIP=( MIN static_assert alignof unreachable )

PATCHES=(
	"${FILESDIR}/inetutils-2.7-telnetd.patch"
)

src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		--disable-clients
		--disable-servers
		$(use_with idn)
		--without-krb4
		$(use_with kerberos krb5)
		--without-shishi
		$(use_with pam)
		$(use_with tcpd wrap)
	)

	local prog
	for prog in ${PROGRAMS}; do
		myconf+=( $(use_enable "${prog}") )
	done

	econf "${myconf[@]}"
}

iu_pamd() {
	if use "$1"; then
		pamd_mimic system-remote-login "$2" auth account password session
	fi
}

create_init() {
	use "$1" || return

	newinitd - "$1" <<-EOF
	#!${EPREFIX}/sbin/openrc-run
	command="${EPREFIX}/usr/libexec/$1"
	command_args="$2"
	pidfile="${EPREFIX}/var/run/$1.pid"
	EOF

	systemd_newunit - "$1.service" <<-EOF
	[Service]
	ExecStart="${EPREFIX}/usr/libexec/$1"${2:+ }$2
	PIDFile=${EPREFIX}/var/run/$1.pid
	Type=forking

	[Install]
	WantedBy=multi-user.target
	EOF
}

create_socket_stream() {
	use "$1" || return

	systemd_newunit - "$1.socket" <<-EOF
	[Socket]
	ListenStream=$2
	Accept=yes

	[Install]
	WantedBy=sockets.target
	EOF

	systemd_newunit - "$1@.service" <<-EOF
	[Unit]
	CollectMode=inactive-or-failed

	[Service]
	ExecStart="${EPREFIX}/usr/libexec/$1"
	StandardInput=socket
	StandardError=journal
	EOF
}

create_socket_datagram() {
	use "$1" || return

	systemd_newunit - "$1.socket" <<-EOF
	[Socket]
	ListenDatagram=$2

	[Install]
	WantedBy=sockets.target
	EOF

	systemd_newunit - "$1.service" <<-EOF
	[Service]
	ExecStart="${EPREFIX}/usr/libexec/$1"
	StandardInput=socket
	StandardError=journal
	EOF
}

src_install() {
	default
	iu_pamd rexecd rexec
	iu_pamd rlogind rlogin
	iu_pamd rshd rsh
	if use kerberos; then
		iu_pamd rlogind krlogin
		iu_pamd rshd krsh
	fi

	create_init ftpd --daemon
	create_init inetd
	create_init rlogind --daemon
	create_init syslogd

	create_socket_stream ftpd 21
	create_socket_stream rexecd 512
	create_socket_stream rlogind 513
	create_socket_stream rshd 514
	create_socket_stream telnetd 23
	create_socket_stream uucpd 540

	create_socket_datagram talkd 518
}
