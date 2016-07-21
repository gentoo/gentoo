# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="A hardware-independent library for executing real-mode x86 code"
HOMEPAGE="http://www.codon.org.uk/~mjg59/libx86"
SRC_URI="http://www.codon.org.uk/~mjg59/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	# fix compile failure with linux-headers-2.6.26, bug 235599
	epatch "${FILESDIR}"/${PN}-0.99-ifmask.patch
	sed -i 's:\($(CC) $(CFLAGS)\)\( -o libx86.so.1\):\1 $(LDFLAGS)\2:' \
		Makefile || die #236888
	tc-export CC AR
}

src_compile() {
	local ARGS
	use amd64 && ARGS="BACKEND=x86emu"
	emake ${ARGS}
}

src_install() {
	emake \
		LIBDIR="/usr/$(get_libdir)" \
		DESTDIR="${D}" \
		install
}
