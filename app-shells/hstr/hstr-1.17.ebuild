# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Shell history suggest box - easily view, navigate, search and manage your command history"
HOMEPAGE="https://github.com/dvorka/hstr http://www.mindforger.com"
SRC_URI="https://github.com/dvorka/hstr/archive/1.17.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ~x86 ppc ppc64 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-tinfo.patch )

DOCS=( CONFIGURATION.md README.md )

src_prepare() {
	sed \
		-e 's:-O2::g' \
		-i src/Makefile.am || die
	autotools-utils_src_prepare
}
