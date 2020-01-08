# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

AKAASH_P="Akaash-0.8.5"
ANI_P="Ani"
LIKHAN_P="Likhan-0.5"
MUKTINARROW_P="MuktiNarrow-0.94"

DESCRIPTION="Unicode compliant Open Type Bangla fonts"
HOMEPAGE="http://www.nongnu.org/freebangfont/index.html"
SRC_BASE="https://savannah.nongnu.org/download/freebangfont"
SRC_URI="
	${SRC_BASE}/${AKAASH_P}.tar.gz
	${SRC_BASE}/${ANI_P}.tar.gz
	${SRC_BASE}/${LIKHAN_P}.tar.gz
	${SRC_BASE}/${MUKTINARROW_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh x86"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf TTF"

src_install() {
	local f
	while IFS="" read -d $'\0' -r f; do
		cp "${f}" . || die
	done < <(find . -name '*.[tT][tT][fF]' -type f -print0)
	font_src_install

	docinto ${AKAASH_P%-*}
	dodoc ${AKAASH_P%-*}/[A-Z][A-Z]*

	docinto ${ANI_P}
	dodoc ${ANI_P}/[A-Z][A-Z]*

	docinto ${LIKHAN_P%-*}
	dodoc ${LIKHAN_P}/README

	docinto ${MUKTINARROW_P%-*}
	dodoc ${MUKTINARROW_P/-/}/{Changelog,readme.txt}
}
