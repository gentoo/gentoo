# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A tool for network monitoring and data acquisition"
HOMEPAGE="https://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpdump"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/the-tcpdump-group/tcpdump"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/tcpdump.asc
	inherit verify-sig

	SRC_URI="https://www.tcpdump.org/release/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://www.tcpdump.org/release/${P}.tar.gz.sig )"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+drop-root +smi +ssl +samba suid test"
REQUIRED_USE="test? ( samba )"

# Assorted failures: bug #768498
RESTRICT="test"

RDEPEND="
	>=net-libs/libpcap-1.10.1
	drop-root? (
		acct-group/pcap
		acct-user/pcap
		sys-libs/libcap-ng
	)
	smi? ( net-libs/libsmi )
	ssl? (
		>=dev-libs/openssl-0.9.6m:0=
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
BDEPEND="drop-root? ( virtual/pkgconfig )"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-tcpdump )"
fi

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
	if [[ ${EUID} -ne 0 ]] || ! use drop-root ; then
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

	if use suid ; then
		fowners root:pcap /usr/sbin/tcpdump
		fperms 4110 /usr/sbin/tcpdump
	fi
}

pkg_postinst() {
	use suid && elog "To let normal users run tcpdump, add them to the pcap group."
}
