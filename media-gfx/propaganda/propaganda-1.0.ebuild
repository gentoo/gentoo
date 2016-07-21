# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

S=${WORKDIR}/Propaganda
DESCRIPTION="Propaganda Volume 1-14 + E. Tiling images for your desktop"
HOMEPAGE="http://www.resexcellence.com/propaganda/index.shtml"
SITE="http://www.resexcellence.com/propaganda/"
# Point to any required sources; these will be automatically
# downloaded by Portage.
SRC_URI="${SITE}Propaganda-Vol-01.tar.gz
	${SITE}Propaganda-Vol-02.tar.gz
	${SITE}Propaganda-Vol-03.tar.gz
	${SITE}Propaganda-Vol-04.tar.gz
	${SITE}Propaganda-Vol-05.tar.gz
	${SITE}Propaganda-Vol-06.tar.gz
	${SITE}Propaganda-Vol-07.tar.gz
	${SITE}Propaganda-Vol-08.tar.gz
	${SITE}Propaganda-Vol-09.tar.gz
	${SITE}Propaganda-Vol-10.tar.gz
	${SITE}Propaganda-Vol-11.tar.gz
	${SITE}Propaganda-Vol-12.tar.gz
	${SITE}Propaganda-13.tar.gz
	${SITE}Propaganda-14.tar.gz
	${SITE}Propaganda-For-E.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

src_compile() {
	rm -fr ${S}/../Propaganda-Vol-11/.finderinfo
	rm -fr ${S}/../Propaganda-Vol-11/.resource

	rm -fr ${S}/../Propaganda-Vol-12/.finderinfo
	rm -fr ${S}/../Propaganda-Vol-12/.resource

	mv ${S}/../Propaganda-Vol-11 ${S}/Vol11
	mv ${S}/../Propaganda-Vol-12 ${S}/Vol12

	for NUM in 1 2 3 4 5 6 7 8 9 10 11 12 13 14; do
		chmod -x ${S}/Vol${NUM}/*
		cd ${S}/Vol${NUM}
		rm *.html
		rename JPG jpg *.JPG
		chmod +x script.perl
		./script.perl *.jpg
	done
	chmod -x ${S}/Propaganda-For-E/*
	cd ${S}/Propaganda-For-E/
	rm *.html
	rename JPG jpg *.JPG
	chmod +x script.perl
	./script.perl *.jpg
	cd ${S}
	pwd
	rm -f ${S}/Vol2/\@
	chmod ugo-w -R ${S}
	chmod ugo+r -R ${S}
}

src_install() {
	dodir /usr/share/pixmaps/
	gunzip magicbg.tar.gz
	dodoc COPYING READM*  magicbg.tar
	mv -f ${S} ${D}/usr/share/pixmaps || die
}
