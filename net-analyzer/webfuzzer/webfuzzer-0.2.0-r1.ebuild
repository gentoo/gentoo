# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/webfuzzer/webfuzzer-0.2.0-r1.ebuild,v 1.3 2014/07/18 03:28:51 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Poor man's web vulnerability scanner"
HOMEPAGE="http://gunzip.altervista.org/g.php?f=projects"
SRC_URI="http://gunzip.altervista.org/webfuzzer/webfuzzer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/devel

src_prepare() {
	sed -i Makefile \
		-e 's|CFLAGS=-g -O3|CFLAGS+=|' \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dodoc CHANGES README TODO
	dobin webfuzzer
}
