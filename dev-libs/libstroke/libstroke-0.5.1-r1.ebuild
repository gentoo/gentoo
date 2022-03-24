# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A Stroke and Gesture recognition Library"
HOMEPAGE="http://www.etla.net/libstroke/"
SRC_URI="http://www.etla.net/libstroke/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-m4_syntax.patch
	"${FILESDIR}"/${P}-no_gtk1.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
