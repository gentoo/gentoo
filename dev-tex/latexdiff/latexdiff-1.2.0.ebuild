# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Compare two latex files and mark up significant differences"
HOMEPAGE="http://www.ctan.org/tex-archive/support/latexdiff/ https://github.com/ftilmann/latexdiff/"
SRC_URI="https://github.com/ftilmann/latexdiff/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE="test"

RDEPEND=">=dev-lang/perl-5.8
	virtual/latex-base
	dev-texlive/texlive-genericrecommended
	dev-perl/Algorithm-Diff"
DEPEND="${RDEPEND}
	dev-perl/Pod-LaTeX
	test? ( app-shells/tcsh )"

src_compile() {
	PATH="${S}/dist:${PATH}" emake -j1 distribution
}

src_test() {
	emake test
}

src_install() {
	cd dist || die
	dobin latexdiff latexrevise latexdiff-vc
	doman latexdiff.1 latexrevise.1 latexdiff-vc.1
	dodoc README doc/latexdiff-man.pdf
}
