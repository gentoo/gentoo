# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 user

DESCRIPTION="A Tool for network monitoring and data acquisition"
EGIT_REPO_URI="https://github.com/the-tcpdump-group/tcpdump"
HOMEPAGE="
	https://www.tcpdump.org/
	https://github.com/the-tcpdump-group/tcpdump
"

LICENSE="BSD"
SLOT="0"
IUSE="+drop-root libressl smi ssl samba suid test"
RESTRICT="!test? ( test )"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/the-${PN}-group/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

RDEPEND="
	drop-root? ( sys-libs/libcap-ng )
	net-libs/libpcap
	smi? ( net-libs/libsmi )
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.6m:0= )
		libressl? ( dev-libs/libressl:= )
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

pkg_setup() {
	if use drop-root || use suid; then
		enewgroup tcpdump
		enewuser tcpdump -1 -1 -1 tcpdump
	fi
}

src_prepare() {
	sed -i -e '/^eapon1/d;' tests/TESTLIST || die

	# bug 630394
	sed -i -e '/^nbns-valgrind/d' tests/TESTLIST || die

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
		$(usex drop-root "--with-user=tcpdump" "")
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
		fowners root:tcpdump /usr/sbin/tcpdump
		fperms 4110 /usr/sbin/tcpdump
	fi
}

pkg_preinst() {
	if use drop-root || use suid; then
		enewgroup tcpdump
		enewuser tcpdump -1 -1 -1 tcpdump
	fi
}

pkg_postinst() {
	use suid && elog "To let normal users run tcpdump add them into tcpdump group."
}
