# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
FONT_PN=${PN%-*}

inherit font

MY_P="${P/-/_bitmap_}"

DESCRIPTION="M+ Japanese bitmap fonts"
HOMEPAGE="https://mplus-fonts.osdn.jp/about-en.html"
SRC_URI="mirror://sourceforge.jp/${PN}/5030/${MY_P}.tar.gz"

LICENSE="mplus-fonts"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE=""
RESTRICT="binchecks strip"

BDEPEND="x11-apps/bdftopcf
	x11-apps/mkfontscale"
S="${WORKDIR}/${MY_P}"

src_install() {
	DESTDIR="${ED}"${FONTDIR} ./install_${PN/-/_} || die
	einstalldocs
}
