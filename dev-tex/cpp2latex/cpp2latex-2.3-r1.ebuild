# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="A program to convert C++ code to LaTeX source"
HOMEPAGE="http://www.arnoldarts.de/cpp2latex/"
SRC_URI="http://www.arnoldarts.de/files/cpp2latex/${P}.tar.gz"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P}/cpp2latex"

src_prepare(){
	echo `ls -al main.cpp`

	# bug #44585
	epatch "${FILESDIR}/${P}.patch"

	# bug 227863
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-tests.patch"
	eapply_user
}
