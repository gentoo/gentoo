# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam

DESCRIPTION="Collection of common network programs"
HOMEPAGE="https://www.gnu.org/software/inetutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

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
	ping? ( !net-misc/iputils )
	ping6? ( !net-misc/iputils[ipv6(+)] )
	rcp? ( !net-misc/netkit-rsh )
	rexec? ( !net-misc/netkit-rsh )
	rlogin? ( !net-misc/netkit-rsh )
	rsh? ( !net-misc/netkit-rsh )
	logger? ( !sys-apps/util-linux[logger(+)] )
	telnet? ( !net-misc/telnet-bsd !net-misc/netkit-telnetd )
	telnetd? ( !net-misc/telnet-bsd !net-misc/netkit-telnetd )
	tftp? ( !net-ftp/tftp-hpa )
	whois? ( !net-misc/whois )
	ifconfig? ( !sys-apps/net-tools )
	traceroute? ( !net-analyzer/traceroute )
"

QA_CONFIG_IMPL_DECL_SKIP=( MIN static_assert alignof unreachable )

src_configure() {
	local myconf=(
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

src_install() {
	default
	iu_pamd rexecd rexec
	iu_pamd rlogind rlogin
	iu_pamd rshd rsh
	if use kerberos; then
		iu_pamd rlogind krlogin
		iu_pamd rshd krsh
	fi
}
