# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/qrna/qrna-2.0.3c-r1.ebuild,v 1.4 2012/12/06 04:15:42 phajdan.jr Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Prototype ncRNA genefinder"
HOMEPAGE="http://selab.janelia.org/software.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	sci-biology/hmmer"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glibc-2.10.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed \
		-e "s:^CC.*:CC = $(tc-getCC):" \
		-e "/^AR/s:ar:$(tc-getAR):g" \
		-e "/^RANLIB/s:ranlib:$(tc-getRANLIB):g" \
		-e "/CFLAGS/s:=.*$:= ${CFLAGS}:" \
		-i {src,squid,squid02}/Makefile || die
	rm -v squid*/*.a
}

src_compile() {
	local dir
	for dir in squid squid02 src; do
		emake -C ${dir}
	done
}

src_install () {
	dobin src/{cfgbuild,eqrna,eqrna_sample,rnamat_main} scripts/*

	newdoc 00README README
	insinto /usr/share/doc/${PF}
	doins documentation/*

	insinto /usr/share/${PN}/data
	doins lib/*
	insinto /usr/share/${PN}/demos
	doins Demos/*

	# Sets the path to the QRNA data files.
	doenvd "${FILESDIR}"/26qrna
}
