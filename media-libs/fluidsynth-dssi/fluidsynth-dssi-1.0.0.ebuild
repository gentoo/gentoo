# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="DSSI Soft Synth Interface"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=media-libs/dssi-0.9.0
	x11-libs/gtk+:2
	>=media-libs/liblo-0.12
	>=media-sound/fluidsynth-1.0.3"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
