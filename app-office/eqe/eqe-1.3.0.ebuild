# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A small LaTeX editor that produces images, with drag and drop support"
HOMEPAGE="http://rlehy.free.fr/"
SRC_URI="http://rlehy.free.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-perl/gtk2-perl
	dev-perl/File-Slurp
	dev-perl/Template-Toolkit
	media-gfx/imagemagick
	virtual/latex-base"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Fix install loction and conform to the Gentoo way
	epatch "${FILESDIR}"/${P}-Makefile.patch || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
