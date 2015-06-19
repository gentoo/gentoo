# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatomic_ops/libatomic_ops-1.2-r1.ebuild,v 1.20 2012/12/16 16:31:21 ulm Exp $

inherit eutils autotools

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="http://www.hpl.hp.com/research/linux/atomic_ops/"
SRC_URI="http://www.hpl.hp.com/research/linux/atomic_ops/download/${P}.tar.gz"

LICENSE="MIT boehm-gc GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ppc64-load_acquire.patch
	epatch "${FILESDIR}"/${P}-ppc-asm.patch
	epatch "${FILESDIR}"/${P}-sh4.patch
	epatch "${FILESDIR}"/${P}-fix-makefile-am-generic.patch
	epatch "${FILESDIR}"/${P}-x32.patch
	eautoreconf
}

src_install() {
	emake pkgdatadir="${EPREFIX}/usr/share/doc/${PF}" DESTDIR="${D}" install || die
}
