# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib eutils versionator

MY_P=$(replace_version_separator 4 '' ${P})

DESCRIPTION="display-oriented editor for binary files, based on the vi texteditor"
HOMEPAGE="http://bvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/bvi/$(replace_version_separator 4 '' ${P}).src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S="${WORKDIR}/$MY_P"

src_prepare() {
	sed -i -e 's:(INSTALL_PROGRAM) -s:(INSTALL_PROGRAM):g' \
		Makefile.in || die "sed failed in Makefile.in"

	epatch_user
}

src_configure() {
	econf --with-ncurses="${EPREFIX}"/usr

	sed -i -e 's:ncurses/term.h:term.h:g' bmore.h || die "sed failed in bmore.h"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	rm -rf "${D}"/usr/$(get_libdir)/bmore.help
	dodoc README CHANGES CREDITS bmore.help
}
