# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Draw any kind of boxes around your text"
HOMEPAGE="https://boxes.thomasjensen.com/ https://github.com/ascii-boxes/boxes"
SRC_URI="https://github.com/ascii-boxes/boxes/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libpcre2:=[pcre32]
	dev-libs/libunistring:=
	sys-libs/ncurses:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	test? ( app-editors/vim-core )
"

PATCHES=( "${FILESDIR}/boxes-2.3.0-ncurses-gentoo.patch" )

src_prepare() {
	default

	sed \
		-e 's:STRIP=true:STRIP=false:g' \
		-i src/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS_ADDTL="${CFLAGS}" LDFLAGS_ADDTL="${LDFLAGS}"
}

src_install() {
	dobin out/boxes
	doman doc/boxes.1
	insinto /usr/share
	newins boxes-config boxes
	einstalldocs
}
