# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="A Tool for network monitoring and data acquisition"
HOMEPAGE="
	https://www.tcpdump.org/
	https://github.com/the-tcpdump-group/tcpdump
"
LICENSE="BSD"
EGIT_REPO_URI="https://github.com/the-tcpdump-group/tcpdump"

SLOT="0"
KEYWORDS=""
IUSE="+drop-root libressl +smi +ssl +samba suid test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( samba )"

RDEPEND="
	net-libs/libpcap
	drop-root? (
		acct-group/pcap
		acct-user/pcap
		sys-libs/libcap-ng
	)
	smi? ( net-libs/libsmi )
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.6m:0= )
		libressl? ( dev-libs/libressl:= )
	)
	suid? (
		acct-group/pcap
		acct-user/pcap
	)
"
BDEPEND="
	drop-root? ( virtual/pkgconfig )
"
DEPEND="
	${RDEPEND}
	test? (
		>=net-libs/libpcap-1.9.1
		dev-lang/perl
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-9999-libdir.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable samba smb) \
		$(use_with drop-root cap-ng) \
		$(use_with drop-root chroot '') \
		$(use_with smi) \
		$(use_with ssl crypto "${ESYSROOT}/usr") \
		$(usex drop-root "--with-user=pcap" "")
}

src_test() {
	if [[ ${EUID} -ne 0 ]] || ! use drop-root; then
		emake check
	else
		ewarn "If you want to run the test suite, make sure you either"
		ewarn "set FEATURES=userpriv or set USE=-drop-root"
	fi
}

src_install() {
	dosbin tcpdump
	doman tcpdump.1
	dodoc *.awk
	dodoc CHANGES CREDITS README.md

	if use suid; then
		fowners root:pcap /usr/sbin/tcpdump
		fperms 4110 /usr/sbin/tcpdump
	fi
}

pkg_postinst() {
	use suid && elog "To let normal users run tcpdump, add them to the pcap group."
}
