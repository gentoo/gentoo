# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Japanese fixed fonts that cover JIS0213 charset"
#HOMEPAGE="http://www12.ocn.ne.jp/~imamura/jisx0213.html"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/jiskan16-2004-1.bdf.gz
	mirror://gentoo/jiskan16-2000-1.bdf.gz
	mirror://gentoo/jiskan16-2000-2.bdf.gz
	mirror://gentoo/K14-2004-1.bdf.gz
	mirror://gentoo/K14-2000-1.bdf.gz
	mirror://gentoo/K14-2000-2.bdf.gz
	mirror://gentoo/K12-1.bdf.gz
	mirror://gentoo/K12-2.bdf.gz
	mirror://gentoo/A14.bdf.gz
	mirror://gentoo/A12.bdf.gz
	mirror://gentoo/jiskan24-2000-1.bdf.gz
	mirror://gentoo/jiskan24-2000-2.bdf.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~s390 ~sparc ~x86"
IUSE=""
RESTRICT="binchecks strip"

BDEPEND="media-gfx/mkbold-mkitalic"
S="${WORKDIR}"

FONT_PN="${PN/-fonts/}"
FONTDIR="/usr/share/fonts/${FONT_PN}"

src_compile() {
	einfo "Making bold and italic faces..."
	for bdf in *.bdf; do
		mkbold       -r -L ${bdf} >${bdf%.bdf}b.bdf
		mkitalic           ${bdf} >${bdf%.bdf}i.bdf
		mkbolditalic -r -L ${bdf} >${bdf%.bdf}bi.bdf
	done
	font-ebdftopcf_src_compile
}

pkg_postinst() {
	font_pkg_postinst
	if use X; then
		elog "You need you add following line into 'Section \"Files\"' in"
		elog "XF86Config and reboot X Window System, to use these fonts."
		elog ""
		elog "\t FontPath \"${FONTDIR}\""
		elog ""
	fi
}
