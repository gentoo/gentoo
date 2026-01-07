# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="yet another dock application showing a system load gauge"
HOMEPAGE="https://www.dockapps.net/wmload"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~x64-solaris"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${PN}-0.9.6-solaris.patch )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	dodoc README
	domenu "${FILESDIR}"/${PN}.desktop
}
