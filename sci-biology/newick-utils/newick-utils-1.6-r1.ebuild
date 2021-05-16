# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools for processing phylogenetic trees"
HOMEPAGE="http://cegg.unige.ch/newick_utils"
SRC_URI="http://cegg.unige.ch/pub/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xml"

DEPEND="
	xml? ( dev-libs/libxml2 )"
RDEPEND="
	${DEPEND}
	!dev-games/libnw"

PATCHES=(
	"${FILESDIR}"/${P}-deduplicate-libnw.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--without-guile \
		--without-lua \
		$(use_with xml libxml)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
