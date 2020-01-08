# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="A LaTeX package for typesetting a curriculum vitae"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/currvita/"
# snapshot taken from
# ftp://ftp.dante.de/tex-archive/macros/latex/contrib/currvita.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-texlive/texlive-langgerman"
RDEPEND="${DEPEND}"

TEXMF="/usr/share/texmf-site"

DOCS=( "README" )

S="${WORKDIR}/${PN}"

src_test() {
	latex currvita.dtx || die "first test of currvita.dtx failed"
	latex currvita.dtx || die "second test of currvita.dtx failed"
	latex currvita.dtx || die "third test of currvita.dtx failed"
	latex cvtest.tex || die "test of cvtest.tex failed"
}
