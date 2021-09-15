# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Really tiny vi clone, for things like rescue disks"
HOMEPAGE="http://www.pell.chi.il.us/~orc/Code/"
SRC_URI="http://www.pell.chi.il.us/~orc/Code/levee/${P}.tar.gz"

LICENSE="levee"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	!app-text/lv
	sys-libs/ncurses:0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4o-darwin.patch
	"${FILESDIR}"/${P}-QA.patch
	"${FILESDIR}"/${PN}-3.5-glibc210.patch
)

src_configure() {
	export AC_CPP_PROG=$(tc-getCPP)
	export AC_PATH="${PATH}"
	export AC_LIBDIR="$($(tc-getPKG_CONFIG) --libs ncurses)"

	./configure.sh \
		--prefix="${PREFIX}"/usr || die "configure failed"
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS} -Wall -Wextra ${LDFLAGS}" \
		CC=$(tc-getCC)
}

src_install() {
	emake PREFIX="${D}/${EPREFIX}" install
}
