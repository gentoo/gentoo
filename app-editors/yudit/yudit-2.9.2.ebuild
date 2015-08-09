# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Free (Y)unicode text editor for all unices"
HOMEPAGE="http://www.yudit.org/"
SRC_URI="http://yudit.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.10"

src_prepare() {
	#Don't strip binaries, let portage do that.
	sed -i "/^INSTALL_PROGRAM/s: -s::" Makefile.conf.in || die "sed failed"
}

src_compile() {
	#FIXME:
	#-j1 because this app builds a tool called 'mytool' and we need to make
	#sure that it is built before it needs to be used.
	emake -j1
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc {BUGS,CHANGELOG,NEWS,TODO,XBUGS}.TXT
}
