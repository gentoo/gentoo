# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="Simple plaintext presentation tool"
HOMEPAGE="https://tools.suckless.org/sent/"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"
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

src_prepare() {
	default

	sed -i \
		-e 's|^ @|  |g' \
		-e 's|@${CC}|$(CC)|g' \
		-e '/^  echo/d' \
		Makefile || die

	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	save_config config.h
}
