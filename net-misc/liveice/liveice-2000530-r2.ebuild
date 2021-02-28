# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Live Source Client For IceCast"
HOMEPAGE="http://star.arm.ac.uk/~spm/software/liveice.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	media-sound/lame
	media-sound/mpg123"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_prepare() {
	default
	eautoreconf
	tc-export CC
}

src_configure() {
	append-flags -fcommon
	default
}

src_install() {
	dobin liveice
	dodoc liveice.cfg README.{liveice,quickstart} README_new_mixer.txt Changes.txt
}
