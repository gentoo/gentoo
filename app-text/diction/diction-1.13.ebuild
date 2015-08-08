# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Diction and style checkers for english and german texts"
HOMEPAGE="http://www.gnu.org/software/diction/diction.html"
SRC_URI="http://www.moria.de/~michael/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DEPEND="
	sys-devel/gettext
	virtual/libintl
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-make.patch
}

DOCS=( NEWS README )
