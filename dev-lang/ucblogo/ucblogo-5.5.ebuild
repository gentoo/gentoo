# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="a reflective, functional programming language"
HOMEPAGE="http://www.cs.berkeley.edu/~bh/logo.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs X"

DEPEND="emacs? ( virtual/emacs )
	X? ( x11-libs/libICE x11-libs/libSM x11-libs/libX11 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-fhs.patch
	epatch "${FILESDIR}"/${P}-dont-require-tetex.patch
	use emacs || epatch "${FILESDIR}"/${P}-no-emacs.patch
#	use emacs || echo 'all install:' > emacs/makefile
}

src_compile() {
	econf $(use_with X x) || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc README
}
