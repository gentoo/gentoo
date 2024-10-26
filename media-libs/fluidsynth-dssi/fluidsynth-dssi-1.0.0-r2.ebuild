# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="DSSI Soft Synth Interface"
HOMEPAGE="https://dssi.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/dssi/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

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

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
