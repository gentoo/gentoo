# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="https://sourceware.org/dwz"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://sourceware.org/git/dwz.git"
	inherit git-r3
else
	SRC_URI="https://sourceware.org/ftp/dwz/releases/${P}.tar.xz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/elfutils
	dev-libs/xxhash
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-debug/gdb
		dev-libs/elfutils[utils]
		dev-util/dejagnu
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-gdb-15.patch
)

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	emake CFLAGS="${CFLAGS}" srcdir="${S}"
}

src_test() {
	emake CFLAGS="${CFLAGS}" srcdir="${S}" check
}

src_install() {
	emake DESTDIR="${D}" CFLAGS="${CFLAGS}" srcdir="${S}" install
}
