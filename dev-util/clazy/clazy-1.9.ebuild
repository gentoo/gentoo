# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Compiler plugin which allows clang to understand Qt semantics"
HOMEPAGE="https://apps.kde.org/en/clazy"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"
IUSE=""

RDEPEND="
	>=sys-devel/clang-5.0:=
	>=sys-devel/llvm-5.0:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare

	sed -e '/install(FILES README.md COPYING-LGPL2.txt checks.json DESTINATION/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	# this package requires both llvm and clang of the same version.
	# clang pulls in the equivalent llvm version, but not vice versa.
	# so, we must find llvm based on the installed clang version.
	# bug #681568
	local clang_version=$(best_version "sys-devel/clang")
	export LLVM_ROOT="/usr/lib/llvm/$(ver_cut 1 ${clang_version##sys-devel/clang-})"
	cmake_src_configure
}
