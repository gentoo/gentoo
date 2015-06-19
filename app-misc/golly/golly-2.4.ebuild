# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/golly/golly-2.4.ebuild,v 1.3 2012/12/26 18:16:45 jdhore Exp $

EAPI=4
PYTHON_DEPEND=2
WX_GTK_VER=2.8

inherit python toolchain-funcs wxwidgets

MY_P=${P}-src
DESCRIPTION="simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/perl
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -e 's:-O2::' -i configure Makefile.{am,in} || die
}

src_configure() {
	econf \
		--with-perl-shlib="libperl.so" \
		--with-python-shlib="$(python_get_library)"
}

src_install() {
	emake docdir= DESTDIR="${D}" install
	dodoc README TODO
}
