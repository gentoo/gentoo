# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simple ncurses-based typing tutor for learning the Dvorak keyboard layout"
HOMEPAGE="http://www.linalco.com/comunidad.html"
SRC_URI="http://www.linalco.com/ragnar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="virtual/pkgconfig"
DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-debian-changes.patch
	"${FILESDIR}"/${PN}-1.6.1-makefile-flags.patch
	"${FILESDIR}"/${PN}-1.6.1-ncurses-pkg-config.patch
	"${FILESDIR}"/${PN}-1.6.1-clang16-build-fix.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake \
		CC="$(tc-getCC)" \
		PROF="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ChangeLog README
}
