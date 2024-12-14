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

	#KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/elfutils
	dev-libs/xxhash
	elibc_musl? (
		>=sys-libs/error-standalone-2.0
		sys-libs/obstack-standalone
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-debug/gdb
		dev-libs/elfutils[utils]
		dev-util/dejagnu
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-gdb-15.patch
	"${FILESDIR}"/${P}-readelf.patch
)

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	tc-export PKG_CONFIG

	export LIBS="-lelf"
	if use elibc_musl; then
		export CFLAGS="${CFLAGS} $(${PKG_CONFIG} --cflags obstack-standalone error-standalone)"
		export LIBS="${LIBS} $(${PKG_CONFIG} --libs obstack-standalone error-standalone)"
	fi

	emake CFLAGS="${CFLAGS}" LIBS="${LIBS}" srcdir="${S}"
}

src_test() {
	emake CFLAGS="${CFLAGS}" LIBS="${LIBS}" srcdir="${S}" check
}

src_install() {
	emake DESTDIR="${D}" CFLAGS="${CFLAGS}" LIBS="${LIBS}" srcdir="${S}" install
}
