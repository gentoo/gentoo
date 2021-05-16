# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Analysis of Compiler Options via Evolutionary Algorithm"
HOMEPAGE="http://www.coyotegulch.com/products/acovea/"
SRC_URI="http://www.coyotegulch.com/distfiles/lib${P}.tar.gz"
S="${WORKDIR}/lib${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	>=dev-libs/libcoyotl-3.1.0:=
	>=dev-libs/libevocosm-3.3.0:=
	dev-libs/expat:="
DEPEND="${RDEPEND}"

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
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
