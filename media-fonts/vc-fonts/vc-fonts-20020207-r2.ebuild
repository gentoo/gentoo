# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font font-ebdftopcf

DESCRIPTION="Vico bitmap Fonts"
SRC_URI="http://vico.kleinplanet.de/files/${P}.tar.bz2
		mirror://gentoo/bleed3.bdf.gz"
HOMEPAGE="http://vico.kleinplanet.de/"

KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT=0
IUSE=""

S="${WORKDIR}/vc"
FONT_S="${S}"
FONT_PN="vc"
FONTDIR="/usr/share/fonts/${FONT_PN}"
FONT_SUFFIX="bdf pcf.gz"

#Only installs fonts
RESTRICT="strip binchecks"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mv "${WORKDIR}"/bleed3.bdf "${S}"
	rm bleed2.pcf.gz
}
