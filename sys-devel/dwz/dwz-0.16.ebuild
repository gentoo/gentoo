# Copyright 1999-2025 Gentoo Authors
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

	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
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
	"${FILESDIR}"/dwz-0.15-readelf.patch
)

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	export LANG=C LC_ALL=C  # grep find nothing for non-ascii locales

	local current_binutils_path=$(binutils-config -B)
	export READELF="${current_binutils_path}/readelf"

	tc-export PKG_CONFIG READELF

	export LIBS="-lelf"
	if use elibc_musl; then
		export CFLAGS="${CFLAGS} $(${PKG_CONFIG} --cflags obstack-standalone error-standalone)"
		export LIBS="${LIBS} $(${PKG_CONFIG} --libs obstack-standalone error-standalone)"
	fi

	emake CFLAGS="${CFLAGS}" LIBS="${LIBS}" srcdir="${S}" prefix="${EPREFIX}/usr"
}

src_test() {
	emake CFLAGS="${CFLAGS}" LIBS="${LIBS}" srcdir="${S}" prefix="${EPREFIX}/usr" check
}

src_install() {
	emake DESTDIR="${D}" CFLAGS="${CFLAGS}" LIBS="${LIBS}" srcdir="${S}" prefix="${EPREFIX}/usr" install
}
