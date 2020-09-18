# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic xdg-utils

DESCRIPTION="Multiplatform vertical shoot-em-up with non-traditional elements"
HOMEPAGE="http://garden.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="<media-libs/allegro-5"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-dash.patch"
	"${FILESDIR}/${P}-resources.patch"
	"${FILESDIR}/${P}-fnocommon.patch"
)

src_prepare() {
	default

	# build with gcc52
	sed -i \
		-e 's/inline/extern inline/' \
		src/stuff.h || die
	eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #572672)
}

src_install() {
	default
	doicon -s scalable resources/garden.svg
	make_desktop_entry garden "Garden of coloured lights"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
