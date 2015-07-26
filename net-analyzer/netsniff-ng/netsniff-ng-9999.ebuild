# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netsniff-ng/netsniff-ng-9999.ebuild,v 1.3 2015/07/21 23:01:41 xmw Exp $

EAPI=5

inherit git-2 eutils multilib toolchain-funcs

DESCRIPTION="high performance network sniffer for packet inspection"
HOMEPAGE="http://netsniff-ng.org/"
EGIT_REPO_URI="git://github.com/borkmann/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/geoip
	dev-libs/libcli
	dev-libs/libnl:3
	dev-libs/userspace-rcu
	net-libs/libnet:1.1
	net-libs/libnetfilter_conntrack
	net-libs/libpcap
	sys-libs/ncurses:5
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	=net-libs/nacl-0_p20110221*
	virtual/pkgconfig"

src_prepare() {
	sed -e '/CFLAGS/s:?=:+=:' \
		-e '/CPPFLAGS/s:?=:+=:' \
		-e '/CFLAGS/s:\(-g\|-O2\|-O3\|-m\(arch\|tune\)=native\)::g' \
		-i Makefile || die

	if ! grep nacl-20110221 curvetun/nacl_build.sh >/dev/null ; then
		die "have nacl-20110221, expected $(grep ${MY_NACL_P} curvetun/nacl_build.sh)"
	fi

	export NACL_INC_DIR="${EROOT}usr/include/nacl"
	export NACL_LIB_DIR="${EROOT}usr/$(get_libdir)/nacl"

	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)" CCACHE="" \
		LEX=lex YAAC=bison STRIP=@true \
		Q= HARDENING=1
}

src_install() {
	emake PREFIX="${ED}usr" ETCDIR="${ED}etc" install

	dodoc AUTHORS README REPORTING-BUGS
}
