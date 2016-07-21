# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit base toolchain-funcs

DESCRIPTION="Knocker is an easy to use security port scanner written in C"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://knocker.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="AUTHORS BUGS ChangeLog NEWS README TO-DO"

PATCHES=( "${FILESDIR}"/${P}-free.patch )

src_prepare() {
	# fix configure checks for compiler, wrt bug #442962
	tc-export CC

	base_src_prepare
}
