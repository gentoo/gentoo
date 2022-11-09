# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Really tiny vi clone, for things like rescue disks"
HOMEPAGE="https://www.pell.portland.or.us/~orc/Code/levee/"
SRC_URI="https://www.pell.portland.or.us/~orc/Code/levee/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches.tar.xz"

LICENSE="levee"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	!app-text/lv
	sys-libs/ncurses:0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}"/${P}-patches
)

src_configure() {
	export AC_CPP_PROG="$(tc-getCPP)"
	export AC_PATH="${PATH}"
	export AC_LIBDIR="$($(tc-getPKG_CONFIG) --libs ncurses)"

	# --sive=256000 because configure.sh expects size to be a number and not the
	# tool lize "llvm-size" or "x86_64-pc-linux-gnu-size".
	# See #729264
	./configure.sh \
		--prefix="${PREFIX}"/usr --size=256000 || die "configure failed"
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${D}/${EPREFIX}" install
}
