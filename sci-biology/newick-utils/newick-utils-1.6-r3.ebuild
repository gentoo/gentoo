# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Tools for processing phylogenetic trees"
HOMEPAGE="https://web.archive.org/web/20120206012743/http://cegg.unige.ch/newick_utils"
SRC_URI="https://web.archive.org/web/20120126210029if_/http://cegg.unige.ch/pub/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xml"

DEPEND="
	xml? ( dev-libs/libxml2:= )"
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
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862279
	# https://github.com/tjunier/newick_utils/issues/34
	filter-lto

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
