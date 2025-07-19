# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib toolchain-funcs

DESCRIPTION="JIT assembler for x86(IA-32)/x64(AMD64, x86-64)"
HOMEPAGE="https://github.com/herumi/xbyak"
SRC_URI="https://github.com/herumi/xbyak/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-lang/yasm
		dev-lang/nasm
	)
"

src_prepare() {
	sed 's/ONLY_64BIT=0/ONLY_64BIT:=0/' -i test/Makefile || die
	cmake_src_prepare
}

src_test() {
	local only_64bit=0
	if use amd64 && { ! has_multilib_profile || [[ $(tc-get-cxx-stdlib) == libc++ ]]; }; then
		only_64bit=1
	fi

	emake -C test test ONLY_64BIT=${only_64bit}
}
