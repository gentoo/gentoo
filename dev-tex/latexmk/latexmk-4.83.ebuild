# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Perl script for automatically building LaTeX documents"
HOMEPAGE="https://personal.psu.edu/~jcc8/software/latexmk/
		  https://ctan.org/pkg/latexmk/"
SRC_URI="https://www.cantab.net/users/johncollins/${PN}/${P/./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos"

RDEPEND="
	dev-lang/perl
	virtual/latex-base
"

DEPEND="${RDEPEND}"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_install() {
	newbin latexmk.pl latexmk
	doman latexmk.1
	dodoc CHANGES README latexmk.pdf latexmk.txt
	dodoc -r example_rcfiles extra-scripts
	newbashcomp "${FILESDIR}"/completion.bash-2 ${PN}
}
