# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/xd3d/xd3d-8.3.1.ebuild,v 1.14 2012/10/16 18:47:38 jlec Exp $

EAPI=4

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="Scientific visualization tool"
HOMEPAGE="http://www.cmap.polytechnique.fr/~jouve/xd3d/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	app-shells/tcsh"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.diff \
		"${FILESDIR}"/${P}-parallel.patch \
		"${FILESDIR}"/${P}-rotated.patch \
		"${FILESDIR}"/${P}-cflags.patch
	sed \
		-e 's:"zutil.h":<zlib.h>:g' \
		-i src/qlib/timestuff.c || die
}

src_configure() {
	tc-export CC
	sed \
		-e "s:##D##:${ED}:" \
		-e "s:##lib##:$(get_libdir):" \
		-i RULES.gentoo \
		|| die "failed to set up RULES.gentoo"
	./configure -arch=gentoo || die "configure failed."
}

src_install() {
	dodir /usr/bin
	emake install

	dodoc BUGS CHANGELOG FAQ FORMATS README
	insinto /usr/share/doc/${PF}
	doins Manuals/*

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r Examples
	fi
}
