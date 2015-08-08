# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils eutils

DESCRIPTION="Script for pretty printing of your mails"
HOMEPAGE="http://muttprint.sourceforge.net"
SRC_URI="mirror://sourceforge/muttprint/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

DEPEND="dev-lang/perl
	virtual/latex-base
	doc? (
		app-text/dvipsk
		app-text/docbook-sgml-utils[jadetex] )"

RDEPEND="dev-lang/perl
	virtual/latex-base
	dev-texlive/texlive-latexextra"

AUTOTOOLS_IN_SOURCE_BUILD=1

patch_docs() {
	sed -i -e 's/db2pdf/docbook2pdf/' "${S}"/configure.ac || die
	for l in de en es it sl
	do
		sed -i -e "/^docdir/s/$/-${PV}/" \
			-e 's/db2/docbook2/' -e 's/ -s / -d /' \
			-e "s|manual-${l}-sed/||" \
			-e "s/mv manual-${l}-sed.dvi/cp manual-${l}-sed.dvi/" \
			"${S}"/doc/manual/${l}/Makefile.am || die
	done
}

src_prepare() {
	epatch "${FILESDIR}/${P}-warning.patch"
	epatch "${FILESDIR}/${P}-manuals.patch"
	epatch "${FILESDIR}/${PF}-pod-encoding.patch"

	if use doc ; then
		# Patch docbook and docdir
		patch_docs
	else
		# Don't do manuals
		sed -i -e '/db2pdf/d' "${S}"/configure.ac || die
	fi
	sed -i -e "/^docdir/s/$/-${PV}/" "${S}"/Makefile.am || die

	# The distfile does not include the png files, nor penguin.jpg
	sed -i -e '/.*png /d' -e '/penguin.jpg /d' "${S}"/pics/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --docdir="/usr/share/doc/${PF}"
}

src_compile() {
	# Parallel build does not work when USE="doc"
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog
}
