# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/xinetd/xinetd-2.3.14-r1.ebuild,v 1.10 2012/08/26 18:31:58 flameeyes Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="powerful replacement for inetd"
HOMEPAGE="http://www.xinetd.org/"
SRC_URI="http://www.xinetd.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="perl rpc tcpd"

DEPEND="tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )
	rpc? ( net-libs/libtirpc )"
RDEPEND="${DEPEND}
	perl? ( dev-lang/perl )"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-DESTDIR.patch
	epatch "${FILESDIR}"/${P}-install-contrib.patch
	epatch "${FILESDIR}"/${P}-config.patch
}

src_configure() {
	if ! use rpc ; then
		append-cppflags -DNO_RPC
		export ac_cv_header_{rpc_{rpc,rpcent,pmap_clnt},netdb}_h=no
	fi
	LIBS=$($(tc-getPKG_CONFIG) --libs libtirpc) \
	econf \
		$(use_with tcpd libwrap) \
		--with-loadavg
}

src_install() {
	emake install install-contrib DESTDIR="${D}" || die
	use perl || rm -f "${D}"/usr/sbin/xconv.pl

	newinitd "${FILESDIR}"/xinetd.rc6 xinetd || die
	newconfd "${FILESDIR}"/xinetd.confd xinetd || die

	newdoc contrib/xinetd.conf xinetd.conf.dist.sample
	dodoc AUDIT INSTALL README TODO CHANGELOG
}
