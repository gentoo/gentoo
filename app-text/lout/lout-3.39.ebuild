# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils toolchain-funcs

IUSE="zlib doc"

DESCRIPTION="high-level language for document formatting"
HOMEPAGE="http://lout.sourceforge.net/"
SRC_URI="mirror://sourceforge/lout/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="zlib? ( >=sys-libs/zlib-1.1.4 )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.38-makefile.patch"
}

src_compile() {
	tc-export CC
	local myconf
	use zlib && myconf="$myconf PDF_COMPRESSION=1 ZLIB=-lz"
	emake COPTS="${CFLAGS}" BINDIR="${EPREFIX}"/usr/bin \
		LOUTLIBDIR="${EPREFIX}"/usr/share/lout \
		LOUTDOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		MANDIR="${EPREFIX}"/usr/share/man/man1 \
		${myconf} lout prg2lout || die "emake prg2lout lout failed"
}

compile_doc() {
	#
	# SYNOPSIS:  compile_doc file times
	#

	einfo "${1}:"
	# yes, it *is* necessary to run this 6 times...
	for i in $(seq 1 $(expr $2 - 1)) ; do
		einfo " pass $i"
		lout all -o ${docdir}/$1 -e /dev/null
	done
	# in the last one, let errors be reported
	einfo " final pass"
	lout all -o ${docdir}/$1 || die "final pass failed"
}

src_install() {
	local bindir libdir docdir mandir
	bindir=${ED}usr/bin
	libdir=${ED}usr/share/lout
	docdir=${ED}usr/share/doc/${PF}
	mandir=${ED}usr/share/man/man1
	export LOUTLIB=${libdir}
	export PATH="${bindir}:${PATH}"

	mkdir -p ${bindir} ${docdir} ${mandir}

	make BINDIR=${bindir} \
		LOUTLIBDIR=${libdir} \
		LOUTDOCDIR=${docdir} \
		MANDIR=${mandir} \
		install installdoc installman || die "make install failed"

	lout -x -s "${ED}"usr/share/lout/include/init || die "lout init failed"

	mv ${docdir}/README{,.docs}
	dodoc README READMEPDF blurb blurb.short whatsnew

	if use doc ; then
		einfo "building postscript documentation (may take a while)"
		cd doc/user
		compile_doc user.ps 6
		cd ../design
		compile_doc design.ps 3
		cd ../expert
		compile_doc expert.ps 4
		cd ../slides
		compile_doc slides.ps 2
	fi
}
