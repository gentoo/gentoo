# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A tool for network monitoring and data acquisition"
HOMEPAGE="https://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpdump"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/the-tcpdump-group/tcpdump"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tcpdump.asc
	inherit verify-sig

	SRC_URI="https://www.tcpdump.org/release/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://www.tcpdump.org/release/${P}.tar.gz.sig )"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+caps +smi +ssl +samba suid test"
REQUIRED_USE="test? ( samba )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=net-libs/libpcap-1.10.1
	caps? (
		acct-group/pcap
		acct-user/pcap
		sys-libs/libcap-ng
	)
	smi? ( net-libs/libsmi )
	ssl? (
		>=dev-libs/openssl-0.9.6m:=
	)
	suid? (
		acct-group/pcap
		acct-user/pcap
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-lang/perl
	)
"
BDEPEND="caps? ( virtual/pkgconfig )"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+=" verify-sig? ( >=sec-keys/openpgp-keys-tcpdump-20240901 )"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-4.99.5-libdir.patch
	"${FILESDIR}"/${PN}-4.99.5-lfs.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable samba smb) \
		$(use_with caps cap-ng) \
		$(use_with smi) \
		$(use_with ssl crypto "${ESYSROOT}/usr") \
		$(usex caps "--with-user=pcap" "")
}

src_test() {
	if [[ ${EUID} -ne 0 ]] || ! use caps ; then
		emake check
	else
		ewarn "If you want to run the test suite, make sure you either"
		ewarn "set FEATURES=userpriv or set USE=-caps"
	fi
}

src_install() {
	dosbin tcpdump
	doman tcpdump.1
	dodoc *.awk
	dodoc CHANGES CREDITS README.md

	if use suid ; then
		fowners root:pcap /usr/sbin/tcpdump
		fperms 4110 /usr/sbin/tcpdump
	fi
}

pkg_postinst() {
	use suid && elog "To let normal users run tcpdump, add them to the pcap group."
}
