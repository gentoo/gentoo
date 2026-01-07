# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Compare two latex files and mark up significant differences"
HOMEPAGE="https://www.ctan.org/tex-archive/support/latexdiff/ https://github.com/ftilmann/latexdiff/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ftilmann/latexdiff.git"
else
	SRC_URI="https://github.com/ftilmann/latexdiff/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
fi

SRC_URI+="
	https://github.com/ftilmann/latexdiff/pull/314/commits/94e13c799d2e218a814d007ceff37e91828fb4a4.patch
		-> ${PN}-1.3.4-makefile-fix-example-diff-target.patch
"

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
"
BDEPEND="
	test? ( app-shells/tcsh )
"

PATCHES=(
	"${DISTDIR}"/${PN}-1.3.4-makefile-fix-example-diff-target.patch
)

src_compile() {
	local -x VARTEXFONTS="${T}/fonts"
	emake -j1 distribution
}

src_install() {
	cd dist || die
	dobin latexdiff latexrevise latexdiff-vc
	doman latexdiff.1 latexrevise.1 latexdiff-vc.1
	dodoc README doc/latexdiff-man.pdf
}
