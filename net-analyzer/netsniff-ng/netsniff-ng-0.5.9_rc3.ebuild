# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netsniff-ng/netsniff-ng-0.5.9_rc3.ebuild,v 1.1 2014/09/01 16:24:28 xmw Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="high performance network sniffer for packet inspection"
HOMEPAGE="http://netsniff-ng.org/"
MY_P=${P/_rc/-rc}
SRC_URI="http://pub.${PN}.org/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e '/CFLAGS/s:?=:+=:' \
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
