# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xkbset/xkbset-0.5-r1.ebuild,v 1.1 2014/09/16 15:25:28 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Manage xkb features such as MouseKeys, AccessX, StickyKeys, BounceKeys and SlowKeys"
HOMEPAGE="http://www.math.missouri.edu/~stephen/software/"
SRC_URI="http://www.math.missouri.edu/~stephen/software/xkbset/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk"

CDEPEND="
	x11-libs/libX11
"
DEPEND="
	${CDEPEND}
"
RDEPEND="
	${CDEPEND}
	tk? ( dev-perl/perl-tk )
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake CC=$(tc-getCC) INC_PATH= LIB_PATH=
}

src_install() {
	dobin xkbset
	use tk && dobin xkbset-gui
	doman xkbset.1
	dodoc README TODO
}
