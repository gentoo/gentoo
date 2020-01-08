# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Create space-efficient, small, read-only romfs filesystems"
HOMEPAGE="http://romfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ~ppc64 s390 x86"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

DOCS=( ChangeLog NEWS genromfs.lsm genrommkdev readme-kernel-patch romfs.txt )

src_compile() {
	tc-export CC
	default
}
