# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Vico bitmap Fonts"
HOMEPAGE="http://vico.kleinplanet.de/"
SRC_URI="
	http://vico.kleinplanet.de/files/${P}.tar.bz2
	mirror://gentoo/bleed3.bdf.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86"
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/vc"

FONT_PN="vc"
FONT_S="${S}"
FONT_SUFFIX="bdf pcf.gz"
FONTDIR="/usr/share/fonts/${FONT_PN}"

src_prepare() {
	default

	mv ../bleed3.bdf . || die
	rm bleed2.pcf.gz || die
}
