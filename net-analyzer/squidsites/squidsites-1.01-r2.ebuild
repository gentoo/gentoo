# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A tool that parses Squid access log file and generates a report of the most visited sites"
LICENSE="GPL-2"
HOMEPAGE="http://www.stefanopassiglia.com/misc.htm"
SRC_URI="http://www.stefanopassiglia.com/downloads/${P}.tar.gz"
SLOT="1"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}/src"

src_prepare() {
	# Respect CFLAGS
	sed -i Makefile \
		-e '/^CCFLAGS=/s|-g| $(CFLAGS) $(LDFLAGS)|' \
		|| die
	epatch "${FILESDIR}"/${P}-format-security.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	cd "${WORKDIR}" || die
	dobin src/squidsites
	dodoc Authors Bugs ChangeLog GNU-Manifesto.html README
}
