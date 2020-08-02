# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic savedconfig toolchain-funcs

DESCRIPTION="an ncurses text editor with an easy-to-read, hackable C source"
HOMEPAGE="https://tools.suckless.org/sandy"
SRC_URI="https://git.suckless.org/${PN}/snapshot/${P}.tar.bz2"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-libs/ncurses:0=
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.4-gentoo.patch
)

src_prepare() {
	default
	restore_config config.h
}

src_compile() {
	tc-export CC PKG_CONFIG
	append-cflags -D_DEFAULT_SOURCE
	emake PREFIX=/usr ${PN}
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	save_config config.h
}
