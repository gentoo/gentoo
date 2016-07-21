# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A program to convert C++ code to LaTeX source"
HOMEPAGE="http://www.arnoldarts.de/drupal/?q=Cpp2LaTeX"
SRC_URI="http://www.arnoldarts.de/drupal/files/downloads/cpp2latex/${P}.tar.gz"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

# although it makes sense to have tex installed, it is
# neither a compile or runtime dependency

src_unpack() {
	unpack ${A}
	cd "${S}/cpp2latex"
	# bug 44585
	epatch "${FILESDIR}/cpp2latex-2.3.patch"
	# bug #227863
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-tests.patch"
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
}
