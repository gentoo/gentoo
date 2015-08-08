# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Perl script to convert HTML files into formatted LaTeX"
HOMEPAGE="http://html2latex.sourceforge.net/"
SRC_URI="mirror://sourceforge/html2latex/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

IUSE="imagemagick libwww"

DEPEND="dev-perl/HTML-Tree
	dev-perl/XML-Simple
	imagemagick? ( media-gfx/imagemagick )
	libwww? ( dev-perl/libwww-perl )"

src_compile() {
	# HTML::LaTex
	cd HTML
	perl-module_src_configure
	perl-module_src_compile
}

src_install() {
	dobin html2latex
	doman html2latex.1
	dodoc README TODO

	# HTML::LaTex
	cd HTML
	perl-module_src_install
	rm unwanted README.win
	rm $(find "${D}" -name README.win.txt) || die
}
