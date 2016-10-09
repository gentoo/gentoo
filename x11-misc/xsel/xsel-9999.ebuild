# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools git-r3

DESCRIPTION="command-line program for getting and setting the contents of the X selection"
HOMEPAGE="http://www.vergenet.net/~conrad/software/xsel"
EGIT_REPO_URI="https://github.com/kfish/xsel.git"

LICENSE="HPND"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-proto/xproto
	x11-libs/libXt
"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}
