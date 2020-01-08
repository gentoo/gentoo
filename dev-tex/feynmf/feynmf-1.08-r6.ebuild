# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit latex-package

DESCRIPTION="Combined LaTeX/Metafont package for drawing of Feynman diagrams"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/feynmf/"
# Taken from: ftp.tug.ctan.org/tex-archive/macros/latex/contrib/${PN}.tar.gz
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.gz
	doc? ( https://dev.gentoo.org/~ulm/distfiles/${PN}-cnl.tar.gz )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="dev-texlive/texlive-metapost"
DEPEND="${RDEPEND}
	dev-lang/perl
	doc? ( dev-texlive/texlive-bibtexextra )"

S="${WORKDIR}/${PN}"
PATCHES=(
	"${FILESDIR}"/${P}.patch
	"${FILESDIR}"/${P}-tempfile.patch
)

src_prepare() {
	rm -f phaip.bst				# use style from bibtexextra
	default
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	emake MP=mpost all manual.ps
	use doc && emake -f Makefile.cnl ps
}

src_install() {
	newbin feynmf.pl feynmf
	doman feynmf.1
	insinto ${TEXMF}/tex/latex/${PN}; doins feynmf.sty feynmp.sty
	insinto ${TEXMF}/metafont/${PN}; doins feynmf.mf
	insinto ${TEXMF}/metapost/${PN}; doins feynmp.mp
	dodoc README manual.ps template.tex
	docompress -x /usr/share/doc/${PF}/manual.ps
	# TEXMF is /usr/share/ plus one further path component
	dosym ../../../../doc/${PF}/manual.ps \
		${TEXMF}/doc/latex/${PN}/${PN}-manual.ps

	if use doc; then
		local f
		for f in fmfcnl*.ps; do
			dodoc ${f}
			docompress -x /usr/share/doc/${PF}/${f}
			dosym ../../../../doc/${PF}/${f} ${TEXMF}/doc/latex/${PN}/${f}
		done
	fi
}
