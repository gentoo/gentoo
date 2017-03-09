# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A linkage disequilibrium association mapping tool"
HOMEPAGE="http://www.daimi.au.dk/~mailund/Blossoc/"
SRC_URI="http://www.daimi.au.dk/~mailund/Blossoc/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/gsl:=
	dev-libs/boost:=
	sci-biology/snpfile"
DEPEND="
	${RDEPEND}
	>=sys-devel/autoconf-archive-2016.09.16
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-gcc43.patch
	"${FILESDIR}"/${PN}-1.4.0-fix-build-system.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	rm m4/ax_boost.m4 || die
	eautoreconf
}
