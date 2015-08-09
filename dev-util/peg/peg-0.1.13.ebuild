# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/strip/d' \
		-e '/^CFLAGS/d' \
		-e 's/$(CFLAGS)/$(CFLAGS) $(LDFLAGS)/g' \
			Makefile || die "sed failed"
}

src_install() {
	mkdir -p "${D}/usr/bin" || die "mkdir failed"
	emake ROOT="${D}" PREFIX="/usr" install
	rm -rf "${D}/usr/man" || die "rm failed"
	doman src/${PN}.1
}

src_test() {
	emake check
	emake test
}
