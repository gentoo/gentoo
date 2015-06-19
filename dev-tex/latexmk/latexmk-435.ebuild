# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latexmk/latexmk-435.ebuild,v 1.13 2014/08/10 21:26:39 slyfox Exp $

EAPI=4

inherit bash-completion-r1

DESCRIPTION="Perl script for automatically building LaTeX documents"
HOMEPAGE="http://www.phys.psu.edu/~collins/software/latexmk/"
SRC_URI="http://www.phys.psu.edu/~collins/software/latexmk/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="virtual/latex-base
	dev-lang/perl"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_install() {
	newbin latexmk.pl latexmk
	doman latexmk.1
	dodoc CHANGES README latexmk.pdf latexmk.ps latexmk.txt
	dodoc -r example_rcfiles extra-scripts
	newbashcomp "${FILESDIR}"/completion.bash-2 ${PN}
}
