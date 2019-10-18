# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Generate Encapsulated Postscript Format files from one-page Postscript documents"
HOMEPAGE="http://www.tm.uka.de/~bless/ps2eps"
SRC_URI="http://www.tm.uka.de/~bless/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	app-text/ghostscript-gpl
	!<app-text/texlive-core-2007-r7"

S="${WORKDIR}/${PN}"

src_configure() {
	tc-export CC
}

src_compile() {
	cd src/C || die
	emake bbox
}

src_install() {
	dobin src/C/bbox
	dobin bin/ps2eps

	doman doc/man/man1/bbox.1
	doman doc/man/man1/ps2eps.1

	local DOCS=( Changes.txt README.txt doc/pdf )
	local HTML_DOCS=( doc/html/. )
	einstalldocs
}
