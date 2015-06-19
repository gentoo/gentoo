# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libf2c/libf2c-20110801-r4.ebuild,v 1.5 2015/05/27 11:21:02 ago Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Library that converts FORTRAN to C source"
HOMEPAGE="http://www.netlib.org/f2c/"
SRC_URI="${HOMEPAGE}/${PN}.zip -> ${P}.zip"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	epatch \
		"${FILESDIR}"/20051004-add-ofiles-dep.patch \
		"${FILESDIR}"/20090407-link-shared-libf2c-correctly.patch \
		"${FILESDIR}"/${P}-main.patch\
		"${FILESDIR}"/${P}-64bit-long.patch \
		"${FILESDIR}"/${P}-format-security.patch
	sed -i -e "s/ld /$(tc-getLD) /" makefile.u || die
}

src_compile() {
	emake \
		-f makefile.u \
		libf2c.so \
		CFLAGS="${CFLAGS} -fPIC" \
		CC="$(tc-getCC)"

	# Clean up files so we can recompile without PIC for the static lib
	if use static-libs; then
		rm *.o || die "clean failed"
		emake \
			-f makefile.u \
			all \
			CFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)"
	fi
}

src_install () {
	dolib libf2c.so.2
	dosym libf2c.so.2 /usr/$(get_libdir)/libf2c.so
	use static-libs && dolib.a libf2c.a
	doheader f2c.h
	dodoc README Notice
}
