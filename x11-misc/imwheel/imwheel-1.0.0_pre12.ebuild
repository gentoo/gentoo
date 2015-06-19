# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/imwheel/imwheel-1.0.0_pre12.ebuild,v 1.8 2008/01/07 10:49:35 nelchael Exp $

inherit eutils

DESCRIPTION="mouse tool for advanced features such as wheels and 3+ buttons"
HOMEPAGE="http://imwheel.sourceforge.net/"
SRC_URI="mirror://sourceforge/imwheel/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext"

DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
	>=sys-apps/sed-4"

S=${WORKDIR}/${P/_/}

src_unpack() {
	unpack ${A}
	cd "${S}"
	#epatch ${FILESDIR}/${P}-gentoo.diff
	sed -i -e "s:/etc:${D}/etc:g" Makefile.am || die
	sed -i -e "s:/etc:${D}/etc:g" Makefile.in || die
}

src_compile() {
	local myconf
	# don't build gpm stuff
	myconf="--disable-gpm --disable-gpm-doc"
	econf ${myconf} || die "configure failed"
	emake || die "parallel make failed"
}

src_install() {
	einstall || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog EMACS M-BA47 NEWS README TODO
}
