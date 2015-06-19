# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/xinetd/xinetd-2.3.14.ebuild,v 1.16 2011/04/16 19:16:41 ulm Exp $

inherit eutils

DESCRIPTION="powerful replacement for inetd"
HOMEPAGE="http://www.xinetd.org/"
SRC_URI="http://www.xinetd.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 ~sparc-fbsd sh sparc x86 ~x86-fbsd"
IUSE="perl tcpd"

DEPEND="tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"
RDEPEND="${DEPEND}
	perl? ( dev-lang/perl )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-DESTDIR.patch
	epatch "${FILESDIR}"/${P}-install-contrib.patch
	epatch "${FILESDIR}"/${P}-config.patch
}

src_compile() {
	econf \
		$(use_with tcpd libwrap) \
		--with-loadavg \
		|| die "econf failed"
	emake || die "Failed to compile"
}

src_install() {
	emake install install-contrib DESTDIR="${D}" || die "failed install"
	use perl || rm -f "${D}"/usr/sbin/xconv.pl

	newinitd "${FILESDIR}"/xinetd.rc6 xinetd || die
	newconfd "${FILESDIR}"/xinetd.confd xinetd || die

	newdoc contrib/xinetd.conf xinetd.conf.dist.sample
	dodoc AUDIT INSTALL README TODO CHANGELOG
}
