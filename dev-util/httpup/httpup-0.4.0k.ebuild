# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="synchronisation tool for http file repositories"
HOMEPAGE="http://jw.tks6.net/files/crux/httpup_manual.html"
SRC_URI="http://jw.tks6.net/files/crux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="net-misc/curl"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-gcc-4.7.patch
	tc-export CC CXX
}

src_install() {
	emake DESTDIR="${D}" \
		mandir="${EPREFIX}/usr/share/man" \
		prefix="${EPREFIX}/usr" install
	dodoc AUTHORS ChangeLog httpup.conf.example README TODO
}
