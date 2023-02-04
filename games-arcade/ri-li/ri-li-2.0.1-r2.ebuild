# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Drive a toy wood engine and collect all the coaches"
HOMEPAGE="https://ri-li.sourceforge.net/"
SRC_URI="mirror://sourceforge/ri-li/Ri-li-${PV}.tar.bz2"
S="${WORKDIR}/Ri-li-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[mod]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.1-gcc43.patch
	"${FILESDIR}"/${PN}-2.0.1-gcc11.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	rm aclocal.m4 || die
	eautoreconf
}

src_install() {
	default

	rm -f "${ED}/usr/share/Ri-li/"*ebuild || die

	newicon data/Ri-li-icon-48x48.png ${PN}.png
	make_desktop_entry Ri_li Ri-li
}
