# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Creates CD-Covers via LaTeX by fetching cd-info from freedb.org or local file"
HOMEPAGE="https://web.archive.org/web/20151104062521/http://www.vanhemert.co.uk/disc-cover.html"
SRC_URI="http://www.vanhemert.co.uk/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
SLOT="0"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Audio-CD-disc-cover
	virtual/latex-base
"

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
