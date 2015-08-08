# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="utilities for configuring and debugging the Linux floppy driver"
HOMEPAGE="http://fdutils.linux.lu/"
SRC_URI="http://fdutils.linux.lu/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="doc"

RDEPEND=">=sys-fs/mtools-3"

DEPEND="${RDEPEND}
	doc? ( virtual/texi2dvi )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# the man 4 fd manpage is better in the man-pages package, so stop it
	# from installing
	epatch "${FILESDIR}/${PN}-no-fd.4-manpage.diff"
	epatch "${FILESDIR}/${P}-destdirfix.patch"
	sed -i -e '/\$(INSTALL) -c/s/ -s / /' src/Makefile.in || die "Failed to sed upstream src/Makefile.in to prevent premature strip"
}

src_compile() {
	econf --enable-fdmount-floppy-only || die

	# parallel make unsafe (bug#315577)
	emake -j1 $(use doc || echo compile) || die "emake failed"
}

src_install() {
	dodoc Changelog
	use doc && dodir /usr/share/info/
	dodir /etc
	emake -j1 DESTDIR="${D}" install || die
}
