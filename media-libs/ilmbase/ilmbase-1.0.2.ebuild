# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit libtool

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 -arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

RDEPEND="!<media-libs/openexr-1.5.0"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-asneeded.patch"
	"${FILESDIR}/${P}-gcc43.patch"
)

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die "Pruning failed"
}
