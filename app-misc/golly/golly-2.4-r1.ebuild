# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/golly/golly-2.4-r1.ebuild,v 1.6 2015/04/08 07:30:34 mgorny Exp $

EAPI=5
WX_GTK_VER=2.8

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 toolchain-funcs wxwidgets

DESCRIPTION="simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/perl
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-src

src_prepare() {
	sed -e 's:-O2::' -i configure Makefile.{am,in} || die
}

src_configure() {
	econf --with-perl-shlib="libperl.so"
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	emake docdir= DESTDIR="${D}" install
	newicon appicon.xpm ${PN}.xpm
	dodoc README TODO
}
