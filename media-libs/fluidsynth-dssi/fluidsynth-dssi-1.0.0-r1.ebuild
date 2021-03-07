# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="DSSI Soft Synth Interface"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="
	media-libs/dssi
	media-libs/liblo
	media-sound/fluidsynth:=
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-fluidsynth2.patch"
)

src_prepare() {
	default
	eautoreconf
}
