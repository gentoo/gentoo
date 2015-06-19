# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/genromfs/genromfs-0.5.2.ebuild,v 1.8 2014/01/18 05:00:53 vapier Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Create space-efficient, small, read-only romfs filesystems"
HOMEPAGE="http://romfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ~ppc64 s390 x86"
IUSE=""

DOCS=( ChangeLog NEWS genromfs.lsm genrommkdev readme-kernel-patch romfs.txt )

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	tc-export CC
	default
}
