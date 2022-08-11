# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Fly a hot air balloon and try to blow the other player out of the screen"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libsdl[video]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default

	sed -i "s|GENTOODIR|${EPREFIX}/usr/share/${PN}|" src/main.c || die

	tc-export CXX PKG_CONFIG
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r images

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Balloon Chase"

	einstalldocs
}
