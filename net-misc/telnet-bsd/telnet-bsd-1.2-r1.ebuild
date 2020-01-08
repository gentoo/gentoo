# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools toolchain-funcs

DESCRIPTION="Telnet and telnetd ported from OpenBSD with IPv6 support"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/ipv6/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="nls xinetd"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}
	!net-misc/netkit-telnetd
	xinetd? ( sys-apps/xinetd )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fbsd.patch
	epatch "${FILESDIR}"/${PN}-1.2-format-security.patch
	eaclocal
	eautoreconf
}

src_configure() {
	# FreeBSD doesn't seem to support PIE neither does hppa
	if use kernel_FreeBSD; then
		export libc_cv_fpie="no"
	fi

	econf
	emake LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	emake DESTDIR="${D}" install

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/telnetd.xinetd telnetd
	fi

	dodoc README THANKS NEWS AUTHORS ChangeLog INSTALL
}
