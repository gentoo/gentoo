# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

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
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86"
IUSE=""
RESTRICT="binchecks strip"

S="${WORKDIR}"

FONT_S="${S}"
FONT_PN="${PN/-fonts/}"
FONTDIR="/usr/share/fonts/${FONT_PN}"

pkg_postinst(){
	if use X; then
		elog "You need you add following line into 'Section \"Files\"' in"
		elog "XF86Config and reboot X Window System, to use these fonts."
		elog ""
		elog "\t FontPath \"${FONTDIR}\""
		elog ""
	fi
}
