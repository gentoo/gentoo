# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils toolchain-funcs

DESCRIPTION="Zero's out all free space on a filesystem"
HOMEPAGE="http://intgat.tigress.co.uk/rmy/uml/index.html"
SRC_URI="http://intgat.tigress.co.uk/rmy/uml/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~mips"
IUSE=""

DEPEND="sys-libs/e2fsprogs-libs"
RDEPEND="${DEPEND}"

src_prepare() {
	# Honor system CFLAGS.
	sed -i \
		-e "s:CC=gcc:CC=$(tc-getCC)\nCFLAGS=${CFLAGS}\nLDFLAGS=${LDFLAGS}:g" \
		-e "s:-o zerofree:\$(CFLAGS) \$(LDFLAGS) -o zerofree:g" \
		-e "/-lext2fs/{ s:-lext2fs::g; s:$: -lext2fs:g; }" \
		Makefile || die "Failed to sed the Makefile"
}

src_compile() {
	# Just a Makefile, nothing fancy.
	make || die "Failed to compile ${PN}."
}

src_install() {
	# Install into /sbin
	into /
	dosbin zerofree
}
