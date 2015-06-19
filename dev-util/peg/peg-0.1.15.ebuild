# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/peg/peg-0.1.15.ebuild,v 1.2 2014/05/10 10:52:39 jauhien Exp $

EAPI=5

DESCRIPTION="Recursive-descent parser generators for C"
HOMEPAGE="http://piumarta.com/software/peg/"
SRC_URI="http://piumarta.com/software/${PN}/${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# FIXME: tests don't respect {C,LD}FLAGS and build stuff in runtime.
RESTRICT="test"

src_prepare() {
	sed -i \
		-e '/strip/d' \
		-e '/^CFLAGS/d' \
		-e 's/$(CFLAGS)/$(CFLAGS) $(LDFLAGS)/g' \
			Makefile || die "sed failed"
}

src_install() {
	dodir "/usr/bin"
	emake ROOT="${D}" PREFIX="/usr" install
	rm -rf "${D}/usr/man" || die "rm failed"
	doman src/${PN}.1
}

src_test() {
	emake check
	emake test
}
