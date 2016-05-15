# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Extremely simple personal calendar program aimed at the Unix geek who wants something minimalistic"
HOMEPAGE="http://www.lightandmatter.com/when/when.html"
SRC_URI="http://www.lightandmatter.com/when/when.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/when_dist

src_prepare() {
	# Fix path for tests
	sed -i 's,^	when,	./when,' Makefile || die 'sed failed'
}

src_compile() { :; }

src_test() {
	# The when command requires these files, or attempts to run setup function.
	mkdir "${HOME}"/.when || die 'mkdir failed'
	touch "${HOME}"/.when/{calendar,preferences} || die 'touch failed'
	emake test
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}
