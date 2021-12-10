# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_MAX_SLOT=12
inherit cmake llvm

DESCRIPTION="Compiler plugin which allows clang to understand Qt semantics"
HOMEPAGE="https://apps.kde.org/clazy"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"
IUSE=""

RDEPEND="<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-build.patch
	"${FILESDIR}"/${P}-use-c++17.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}" && has_version "sys-devel/llvm:${LLVM_SLOT}"
}

src_prepare() {
	cmake_src_prepare

	sed -e '/install(FILES README.md COPYING-LGPL2.txt checks.json DESTINATION/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	export LLVM_ROOT="$(get_llvm_prefix -d ${LLVM_MAX_SLOT})"

	cmake_src_configure
}

src_test() {
	# Run tests against built copy, not installed
	# bug #811723
	PATH="${BUILD_DIR}/bin:${PATH}" LD_LIBRARY_PATH="${BUILD_DIR}/lib" cmake_src_test
}
