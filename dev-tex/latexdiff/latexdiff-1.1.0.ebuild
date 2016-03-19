# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Compare two latex files and mark up significant differences"
HOMEPAGE="http://www.ctan.org/tex-archive/support/latexdiff/ https://github.com/ftilmann/latexdiff/"
SRC_URI="http://mirror.ctan.org/support/${PN}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE=""

RDEPEND=">=dev-lang/perl-5.8
	dev-perl/Algorithm-Diff"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}

src_test() {
	emake test-ext
}

src_install() {
	dobin latexdiff latexrevise latexdiff-vc
	doman latexdiff.1 latexrevise.1 latexdiff-vc.1
	dodoc README doc/latexdiff-man.pdf
}
