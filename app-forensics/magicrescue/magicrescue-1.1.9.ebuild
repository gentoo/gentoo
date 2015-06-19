# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/magicrescue/magicrescue-1.1.9.ebuild,v 1.7 2013/04/11 06:17:30 patrick Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Find deleted files in block devices"
HOMEPAGE="http://www.itu.dk/people/jobr/magicrescue/"
SRC_URI="http://www.itu.dk/people/jobr/magicrescue/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="|| ( sys-libs/gdbm sys-libs/db )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	tc-export CC
}

src_configure() {
	# Not autotools, just looks like it sometimes
	./configure --prefix=/usr || die
}
