# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="reimplement libdjb - excellent libraries from Dan Bernstein"
SRC_URI="http://dl.fefe.de/${P}.tar.bz2"
HOMEPAGE="http://www.fefe.de/libowfat/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="diet"

RDEPEND="diet? ( >=dev-libs/dietlibc-0.33_pre20090721 )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

pkg_setup() {
	# Required for mult/umult64.c to be usable
	append-flags -fomit-frame-pointer
}

src_prepare() {
	sed -e "s:^CFLAGS.*:CFLAGS=-I. ${CFLAGS}:" \
		-e "s:^DIET.*:DIET?=/usr/bin/diet -Os:" \
		-e "s:^prefix.*:prefix=/usr:" \
		-e "s:^INCLUDEDIR.*:INCLUDEDIR=\${prefix}/include/libowfat:" \
		-i GNUmakefile || die "sed failed"
	epatch "${FILESDIR}/libowfat-0.28-GNUmakefile.patch"
}

src_compile() {
	emake -j1 \
		CC=$(tc-getCC) \
		$( use diet || echo 'DIET=' )
}

src_install () {
	emake -j1 \
		LIBDIR="${D}/usr/lib" \
		MAN3DIR="${D}/usr/share/man/man3" \
		INCLUDEDIR="${D}/usr/include/libowfat" \
		install || die "emake install failed"

	cd "${D}"/usr/share/man
	mv man3/buffer.3 man3/owfat-buffer.3
}
