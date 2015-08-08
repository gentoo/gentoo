# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit eutils

DESCRIPTION="RATS - Rough Auditing Tool for Security"
HOMEPAGE="http://www.fortifysoftware.com/security-resources/rats.jsp"
SRC_URI="http://www.fortifysoftware.com/servlet/downloads/public/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="dev-libs/expat"

src_prepare() {
	epatch "${FILESDIR}"/${P}-add-getopt-trailing-null.patch
	epatch "${FILESDIR}"/${P}-fix-null-pointers.patch
}

src_configure() {
	econf --datadir="${EPREFIX}/usr/share/${PN}/"
}

src_install () {
	einstall SHAREDIR="${ED}/usr/share/${PN}" MANDIR="${ED}/usr/share/man"
	dodoc README README.win32
}

pkg_postinst() {
	ewarn "Please be careful when using this program with it's force language"
	ewarn "option, '--language <LANG>' it may take huge amounts of memory when"
	ewarn "it tries to treat binary files as some other type."
}
