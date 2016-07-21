# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Shell history suggest box"
HOMEPAGE="https://github.com/dvorka/hstr http://www.mindforger.com"
SRC_URI="https://github.com/dvorka/hstr/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( CONFIGURATION.md README.md )

src_prepare() {
	sed \
		-e 's:-O2::g' \
		-i src/Makefile.am || die
	autotools-utils_src_prepare
}
