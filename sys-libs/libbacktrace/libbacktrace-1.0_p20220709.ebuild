# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

COMMITHASH="8602fda64e78f1f46563220f2ee9f7e70819c51d"
SRC_URI="https://github.com/ianlancetaylor/libbacktrace/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMITHASH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~riscv"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/libbacktrace-1.0_p20220709-teststatic.patch"
)

BDEPEND="
	test? (
		app-arch/xz-utils
		sys-libs/zlib
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-shared \
		$(use_enable static{-libs,})
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
