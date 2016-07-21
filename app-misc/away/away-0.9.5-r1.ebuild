# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit pam toolchain-funcs flag-o-matic

DESCRIPTION="Terminal locking program with few additional features"
HOMEPAGE="http://unbeatenpath.net/software/away/"
SRC_URI="http://unbeatenpath.net/software/away/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=sys-libs/pam-0.75"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}

	sed -i -e '/-o \$(BINARY)/d' \
		-e 's:LIBS:LDLIBS:' \
		"${S}"/Makefile || die "Makefile fix failed"
}
src_compile() {
	append-flags -pthread

	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	dobin away || die "dobin failed"

	pamd_mimic_system away auth

	doman doc/*
	dodoc BUGS AUTHORS NEWS README TODO data/awayrc || die "dodoc failed"
}
