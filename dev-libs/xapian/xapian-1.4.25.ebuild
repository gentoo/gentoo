# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}-core-${PV}"
DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="https://xapian.org/"
SRC_URI="https://oligarchy.co.uk/xapian/${PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/30" # ABI version of libxapian.so
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos ~x64-solaris"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 debug static-libs"

DEPEND="
	sys-libs/zlib:=
	!elibc_Darwin? ( !elibc_SunOS? ( sys-apps/util-linux ) )
	elibc_SunOS? ( sys-libs/libuuid )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS HACKING PLATFORMS README NEWS )

src_configure() {
	tc-export_build_env BUILD_CC
	local -x CC_FOR_BUILD="${BUILD_CC}"

	# skip certain autoconf checks
	local -x VALGRIND=
	local -x EATMYDATA=

	local -a myconf=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		--disable-werror
		--enable-backend-chert
		--enable-backend-glass
		--enable-backend-inmemory
		--enable-backend-remote
		--program-suffix=
		$(use_enable debug assertions)
		$(use_enable debug log)
		$(use_enable static-libs static)
	)

	if use cpu_flags_x86_sse2; then
		myconf+=( --enable-sse=sse2 )
	elif use cpu_flags_x86_sse; then
		myconf+=( --enable-sse=sse )
	else
		myconf+=( --disable-sse )
	fi

	econf "${myconf[@]}"
}

src_test() {
	emake -Onone check
}

src_install() {
	default
	find "${ED}" -name "*.la" -type f -delete || die
}
