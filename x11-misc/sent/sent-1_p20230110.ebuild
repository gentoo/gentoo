# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="Simple plaintext presentation tool"
HOMEPAGE="https://tools.suckless.org/sent/"
SRC_URI="https://dl.suckless.org/tools/${PN}-1.tar.gz"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
"
RDEPEND="
	${DEPEND}
	!savedconfig? ( media-gfx/farbfeld )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1-fix_mk.patch
	"${FILESDIR}"/${P}.patch
)

src_prepare() {
	default

	restore_config config.h
}

src_compile() {
	tc-export CC PKG_CONFIG
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	save_config config.h
}
