# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdftk/pdftk-2.02.ebuild,v 1.4 2015/01/26 10:19:34 ago Exp $

EAPI="5"

inherit eutils

DESCRIPTION="A tool for manipulating PDF documents"
HOMEPAGE="http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/"
SRC_URI="http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux"

DEPEND="sys-devel/gcc[gcj]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-dist/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	# Settings by java-config break compilation by gcj.
	unset CLASSPATH
	unset JAVA_HOME

	# Parallel make fails; confirmed, still not fixed in version 2.02.
	emake -j1 -f "${S}"/Makefile.Debian || die "Compilation failed."
}

src_install() {
	dobin pdftk
	doman ../pdftk.1
	dohtml ../pdftk.1.html
}
