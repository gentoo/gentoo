# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Extract files from Amiga adf disk images"
SRC_URI="http://perso.club-internet.fr/lclevy/adflib/adflib.zip"
HOMEPAGE="http://perso.club-internet.fr/lclevy/adflib/adflib.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="hppa ppc x86 ~x86-interix ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""
DEPEND="app-arch/unzip
		x11-misc/makedepend"
RDEPEND=""

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	unzip "${DISTDIR}"/adflib.zip
	epatch "${FILESDIR}"/no.in_path.patch
}

src_compile() {
	cd "${S}"/Lib && make depend || die "make failed"
	cd "${S}"/Demo && make depend || die "make failed"
	cd "${S}" && emake lib demo || die "emake failed"
}

src_install() {
	dobin Demo/unadf
	dodoc README CHANGES Faq/adf_info.txt
	docinto Docs
	dodoc Docs/*
	docinto Faq
	dodoc Faq/*
	docinto Faq/image
	dodoc Faq/image/*
}
