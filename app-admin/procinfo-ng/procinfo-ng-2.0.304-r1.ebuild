# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils toolchain-funcs

DESCRIPTION="Completely rewrite of the old system monitoring app procinfo"
HOMEPAGE="http://sourceforge.net/projects/procinfo-ng/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

RDEPEND="
	sys-libs/ncurses
	!app-admin/procinfo"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-man.patch
	)

src_prepare() {
	epatch ${PATCHES[@]}
	# removing -s flag as portage does the stripping part and add support
	# for custom LDFLAGS. Plus correct for --as-needed
	sed \
		-e 's:-s -lncurses:${LDFLAGS}:' \
		-i configure.in || die "sed configure.in failed"
	eautoreconf
}

src_compile() {
	emake LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}
