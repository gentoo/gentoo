# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
S="${WORKDIR}/Propaganda"
DESCRIPTION="Propaganda Volume 1-14 + E. Tiling images for your desktop"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SITE="https://dev.gentoo.org/~andrey_utkin/distfiles/"
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
LICENSE="GPL-2+"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

src_prepare() {
	default

	mv ../Propaganda-Vol-11 Vol11 || die
	mv ../Propaganda-Vol-12 Vol12 || die

	rename JPG jpg */*.JPG || die
}

src_install() {
	dodoc README-PROPAGANDA

	local VOLUME
	for VOLUME in Vol* Propaganda-For-E; do
		insinto "/usr/share/pixmaps/Propaganda/${VOLUME}"
		doins "${VOLUME}"/*.jpg
	done
}
