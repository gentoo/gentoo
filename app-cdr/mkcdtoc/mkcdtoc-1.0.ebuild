# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="command-line utility to create toc-files for cdrdao"
HOMEPAGE="http://sourceforge.net/projects/mkcdtoc/"
SRC_URI="mirror://sourceforge/mkcdtoc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.0"
RDEPEND="${DEPEND}"

src_compile() {
	emake PREFIX="/usr" || die "emake failed"
}

src_install() {
	emake PREFIX="/usr" MANDIR="/usr/share/man" DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
