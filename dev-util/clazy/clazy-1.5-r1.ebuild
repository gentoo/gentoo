# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Compiler plugin which allows clang to understand Qt semantics"
HOMEPAGE="https://cgit.kde.org/clazy.git/tree/README.md"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	sys-devel/clang:=
	>=sys-devel/llvm-3.8:=
"
DEPEND="${RDEPEND}"

DOCS=( README.md )

src_prepare() {
	cmake_src_prepare

	sed -e '/install(FILES README.md COPYING-LGPL2.txt checks.json DESTINATION/d' \
		-i CMakeLists.txt || die

	sed -e 's|${MAN_INSTALL_DIR}|share/man/man1|' \
		-i docs/man/CMakeLists.txt || die
}

src_configure() {
	# this package requires both llvm and clang of the same version.
	# clang pulls in the equivalent llvm version, but not vice versa.
	# so, we must find llvm based on the installed clang version.
	# bug #681568
	local clang_version=$(best_version sys-devel/clang)
	export LLVM_ROOT="/usr/lib/llvm/$(ver_cut 1 ${clang_version##sys-devel/clang-})"
	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${D}"/usr/share/doc/clazy/* "${D}"/usr/share/doc/${PF} || die
	rmdir "${D}"/usr/share/doc/clazy || die
}
