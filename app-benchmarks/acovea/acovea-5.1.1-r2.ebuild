# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Analysis of Compiler Options via Evolutionary Algorithm"
HOMEPAGE="http://www.coyotegulch.com/products/acovea/"
SRC_URI="http://www.coyotegulch.com/distfiles/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

RDEPEND="
	>=dev-libs/libcoyotl-3.1.0:=
	>=dev-libs/libevocosm-3.3.0:=
	dev-libs/expat:="
DEPEND="${RDEPEND}"

S=${WORKDIR}/lib${P}

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-free-fix.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-glibc-212.patch
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-libevocosm.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
