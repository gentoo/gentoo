# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Stroke and Gesture recognition Library"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

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

	eautoreconf
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
