# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/currvita/currvita-0.9i-r1.ebuild,v 1.19 2012/05/09 17:13:57 aballier Exp $

inherit latex-package

DESCRIPTION="A LaTeX package for typesetting a curriculum vitae"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/currvita/"
# snapshot taken from
# ftp://ftp.dante.de/tex-archive/macros/latex/contrib/currvita.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE=""

# >=tetex-2 includes currvita
DEPEND="!>=app-text/tetex-2
	!app-text/ptex"

S="${WORKDIR}/${PN}"

TEXMF="/usr/share/texmf-site"
DOCS="README"

src_test() {
	latex currvita.dtx || die "first step of currvita.dtx failed"
	latex currvita.dtx || die "second step of currvita.dtx failed"
	latex currvita.dtx || die "third step of currvita.dtx failed"
	latex cvtest.tex || die "processing cvtest.tex failed"
}
