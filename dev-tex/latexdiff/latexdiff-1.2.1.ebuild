# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Compare two latex files and mark up significant differences"
HOMEPAGE="http://www.ctan.org/tex-archive/support/latexdiff/ https://github.com/ftilmann/latexdiff/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ftilmann/latexdiff.git"
else
	SRC_URI="https://github.com/ftilmann/latexdiff/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.8
	virtual/latex-base
	dev-texlive/texlive-plaingeneric
	dev-perl/Algorithm-Diff
"
DEPEND="${RDEPEND}
	dev-perl/Pod-LaTeX
	test? ( app-shells/tcsh )
"

src_compile() {
	export VARTEXFONTS="${T}/fonts"
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
