# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latexdiff/latexdiff-0.5.ebuild,v 1.20 2012/05/09 17:10:42 aballier Exp $

DESCRIPTION="Compare two latex files and mark up significant differences"
HOMEPAGE="http://www.ctan.org/tex-archive/support/latexdiff/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE=""

RDEPEND=">=dev-lang/perl-5.8
	dev-perl/Algorithm-Diff"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}

src_test() {
	emake test-ext || die "Tests failed!"
}

src_install() {
	dobin latexdiff latexrevise latexdiff-vc || die "dobin failed"
	doman latexdiff.1 latexrevise.1 latexdiff-vc.1 || die "doman failed"
	dodoc CHANGES README latexdiff-man.pdf || die "dodoc failed"
}
