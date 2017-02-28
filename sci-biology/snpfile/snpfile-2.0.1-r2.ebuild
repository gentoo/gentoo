# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A library and API for manipulating large SNP datasets"
HOMEPAGE="http://www.birc.au.dk/~mailund/SNPFile/"
SRC_URI="http://www.birc.au.dk/~mailund/SNPFile/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="static-libs"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/boost:="
DEPEND="
	${RDEPEND}
	>=sys-devel/autoconf-archive-2016.09.16"

PATCHES=(
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-gentoo.diff
	"${FILESDIR}"/${P}-gold.patch
	"${FILESDIR}"/${P}-ax-boost.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	rm m4/ax_boost.m4 || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
