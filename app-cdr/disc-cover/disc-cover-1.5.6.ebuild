# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/disc-cover/disc-cover-1.5.6.ebuild,v 1.7 2014/08/10 02:14:17 patrick Exp $

DESCRIPTION="Creates CD-Covers via LaTeX by fetching cd-info from freedb.org or local file"
HOMEPAGE="http://www.vanhemert.co.uk/disc-cover.html"
SRC_URI="http://www.vanhemert.co.uk/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE="cdrom"

SLOT="0"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	virtual/latex-base
	cdrom? ( dev-perl/Audio-CD-disc-cover )"

src_compile() {
	pod2man disc-cover > disc-cover.1 || die
}

src_install() {
	dobin disc-cover
	dodoc AUTHORS CHANGELOG TODO
	doman disc-cover.1
	insinto /usr/share/${PN}/templates
	doins templates/*
}
