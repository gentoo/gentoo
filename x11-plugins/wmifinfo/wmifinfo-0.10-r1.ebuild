# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="a dockapp for monitoring network interfaces"
HOMEPAGE="https://www.dockapps.net/wmifinfo"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

S="${WORKDIR}/dockapps"

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README Changelog
}
