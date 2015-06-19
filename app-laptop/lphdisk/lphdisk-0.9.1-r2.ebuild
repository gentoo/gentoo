# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/lphdisk/lphdisk-0.9.1-r2.ebuild,v 1.3 2010/08/09 19:29:58 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="utility for preparing a hibernation partition for APM Suspend-To-Disk"
HOMEPAGE="http://www.procyon.com/~pda/lphdisk/"
SRC_URI="http://www.procyon.com/~pda/lphdisk/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-libs/lrmi"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
