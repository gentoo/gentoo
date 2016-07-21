# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="SoundFontCombi is an opensource software pseudo synthesizer"
HOMEPAGE="http://personal.telefonica.terra.es/web/soudfontcombi/"
SRC_URI="http://personal.telefonica.terra.es/web/soudfontcombi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	media-libs/alsa-lib
	x11-libs/fltk:1"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "/CXXFLAGS/s:-O3:${CXXFLAGS}:" configure.in || die
	epatch_user
	eautoreconf
}
