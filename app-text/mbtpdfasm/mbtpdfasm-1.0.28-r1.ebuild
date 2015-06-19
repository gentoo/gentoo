# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mbtpdfasm/mbtpdfasm-1.0.28-r1.ebuild,v 1.3 2014/08/10 18:26:52 slyfox Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_P="mbtPdfAsm-${PV}"

DESCRIPTION="Tool to assemble/merge PDF files, extract information from, and update the metadata in PDF files"
HOMEPAGE="http://thierry.schmit.free.fr/dev/mbtPdfAsm/mbtPdfAsm2.html"
SRC_URI="http://thierry.schmit.free.fr/spip/IMG/gz/${MY_P}.tar.gz
	http://sbriesen.de/gentoo/distfiles/${P}-manual.pdf.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.diff"
	epatch "${FILESDIR}/${P}-64bit.diff"
	epatch "${FILESDIR}/${P}-main.diff"

	# use system zlib
	epatch "${FILESDIR}/${P}-zlib.diff"
	mv -f "zlib.h" "zlib.h.disabled"
}

src_compile() {
	emake CC="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dobin mbtPdfAsm || die "install failed"
	insinto "/usr/share/doc/${PF}"
	newins ${P}-manual.pdf mbtPdfAsm.pdf
}
