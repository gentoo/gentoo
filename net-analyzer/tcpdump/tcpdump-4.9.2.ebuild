# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs user

DESCRIPTION="A Tool for network monitoring and data acquisition"
HOMEPAGE="
	http://www.tcpdump.org/
	https://github.com/the-tcpdump-group/tcpdump
"
SRC_URI="
	http://www.tcpdump.org/release/${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+drop-root libressl smi ssl samba suid test"

RDEPEND="
	drop-root? ( sys-libs/libcap-ng )
	net-libs/libpcap
	smi? ( net-libs/libsmi )
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.6m:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="
	${RDEPEND}
	drop-root? ( virtual/pkgconfig )
	test? (
		|| ( app-arch/sharutils sys-freebsd/freebsd-ubin )
		dev-lang/perl
	)
"

pkg_setup() {
	if use drop-root || use suid; then
		enewgroup tcpdump
		enewuser tcpdump -1 -1 -1 tcpdump
	fi
}

src_prepare() {
	default

	sed -i -e '/^eapon1/d;' tests/TESTLIST || die

	# bug 630394
	sed -i -e '/^nbns-valgrind/d' tests/TESTLIST || die
}

src_configure() {
	if use drop-root; then
		append-cppflags -DHAVE_CAP_NG_H
		export LIBS=$( $(tc-getPKG_CONFIG) --libs libcap-ng )
	fi

	econf \
		$(use_enable samba smb) \
		$(use_with drop-root chroot '') \
		$(use_with smi) \
		$(use_with ssl crypto "${EPREFIX}/usr") \
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
