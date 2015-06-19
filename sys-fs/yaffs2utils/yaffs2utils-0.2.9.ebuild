# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/yaffs2utils/yaffs2utils-0.2.9.ebuild,v 1.1 2014/12/31 02:32:37 vapier Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="tools for generating YAFFS images"
HOMEPAGE="http://code.google.com/p/yaffs2utils/"
SRC_URI="https://yaffs2utils.googlecode.com/files/0.2.9.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE=""

S=${WORKDIR}/${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-unyaffs2-pointer.patch
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin unspare2 mkyaffs2 unyaffs2
	dodoc CHANGES README
}
