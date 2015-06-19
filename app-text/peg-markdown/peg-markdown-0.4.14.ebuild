# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/peg-markdown/peg-markdown-0.4.14.ebuild,v 1.2 2015/06/06 08:14:24 jlec Exp $

EAPI=5

DESCRIPTION="Implementation of markdown in C, using a PEG grammar"
HOMEPAGE="https://github.com/jgm/peg-markdown"
SRC_URI="https://github.com/jgm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 MIT )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/peg
	test? (
		dev-lang/perl
		virtual/perl-Getopt-Long
		app-text/htmltidy )"

src_prepare() {
	rm -rf peg-* || die "rm failed"
	sed -i \
		-e 's/^PROGRAM=markdown/PROGRAM=peg-markdown/' \
		-e 's/$(CC) `/$(CC) $(LDFLAGS) `/g' \
		-e 's/^\t$(LEG)/\tleg/' \
		-e 's/^$(PEGDIR):/dummy:/' \
		-e '/$(PEGDIR)/d' \
		-e 's/$(LEG) //g' \
			Makefile || die 'sed failed'
	sed -i \
		-e '/strdup/d' markdown_peg.h || die 'sed .h failed'
}

src_install() {
	dobin peg-markdown
	dodoc README.markdown
}
