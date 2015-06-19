# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/zoo/zoo-2.10-r4.ebuild,v 1.10 2014/08/10 01:43:11 patrick Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Manipulate archives of files in compressed form"
HOMEPAGE="ftp://ftp.kiarchive.ru/pub/unix/arcers"
SRC_URI="ftp://ftp.kiarchive.ru/pub/unix/arcers/${P}pl1.tar.gz
	mirror://gentoo/${P}-gcc-issues-fix.patch"

LICENSE="zoo"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch "${DISTDIR}"/${P}-gcc-issues-fix.patch
	epatch "${FILESDIR}"/${P}-CAN-2005-2349.patch
	epatch "${FILESDIR}"/${P}-febz-183426.patch
	epatch "${FILESDIR}"/${P}-security_pathsize.patch
	epatch "${FILESDIR}"/${P}-multiple-dos-fix.patch
	epatch "${FILESDIR}"/${P}-gentoo-fbsd.patch
}

src_compile() {
	# emake no workie on FreeBSD
	make CC="$(tc-getCC)" linux || die
}

src_install() {
	dobin zoo fiz || die
	doman zoo.1 fiz.1
}
