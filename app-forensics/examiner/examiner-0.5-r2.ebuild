# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/examiner/examiner-0.5-r2.ebuild,v 1.5 2012/11/20 20:57:56 ago Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Application that utilizes the objdump command to disassemble and comment foreign executable binaries"
HOMEPAGE="http://www.academicunderground.org/examiner/"
SRC_URI="http://www.academicunderground.org/examiner/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

src_prepare() {
	# Do not install docs through Makefile wrt bug #241256
	sed -i -e '/$(DOC)/d' Makefile || die 'sed failed'
	epatch "${FILESDIR}"/${P}-perl.patch
}

src_compile() {	:; }

src_install() {
	dodir /usr/bin /usr/share/${PN} /usr/share/man/man1

	emake \
		MAN="${D}/usr/share/man/man1" \
		BIN="${D}/usr/bin" \
		SHARE="${D}/usr/share/examiner" \
		install

	dodoc docs/{README*,BUGS,CHANGELOG,TODO,TUTORIAL}
	dodoc -r utils
}
