# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Draw any kind of boxes around your text"
HOMEPAGE="https://boxes.thomasjensen.com/ https://github.com/ascii-boxes/boxes"
SRC_URI="https://github.com/ascii-boxes/boxes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libpcre2[pcre32]
	dev-libs/libunistring:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( app-editors/vim-core )
"

PATCHES=( "${FILESDIR}/${P}-fix-clang16-build.patch" )

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
