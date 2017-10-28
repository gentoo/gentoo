# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Routing application based on openstreetmap data"
HOMEPAGE="http://www.routino.org/"
SRC_URI="http://www.routino.org/download/${P}.tgz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=""

src_prepare() {
	eapply "${FILESDIR}"/${P}.patch

	sed -i -e "s@libdir=\(.*\)@libdir=\$(prefix)/$(get_libdir)@" \
		-e "s@CC=gcc@CC=$(tc-getCC)@" \
		-e "s@LD=gcc@LD=$(tc-getCC)@" \
		Makefile.conf || die "failed sed"

	eapply_user
}

src_compile() {
	emake -j1
	rm README.txt
	mv doc/rm README.txt .
}
