# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils gnome2-utils autotools flag-o-matic

DESCRIPTION="Multiplatform vertical shoot-em-up with non-traditional elements"
HOMEPAGE="http://garden.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="<media-libs/allegro-5"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-dash.patch"
	"${FILESDIR}/${P}-resources.patch"
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
	DOCS="AUTHORS ChangeLog NEWS README" \
		default
	doicon -s scalable resources/garden.svg
	make_desktop_entry garden "Garden of coloured lights"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
