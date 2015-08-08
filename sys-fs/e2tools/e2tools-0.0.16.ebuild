# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="utilities to read, write, and manipulate files in an ext2/ext3 filesystem"
HOMEPAGE="http://home.earthlink.net/~k_sheff/sw/e2tools/index.html"
SRC_URI="http://home.earthlink.net/~k_sheff/sw/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '/e2cp_LDADD/s:-L@[^@]*@::' Makefile.in || die
}
