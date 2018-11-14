# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Compiler plugin which allows clang to understand Qt semantics"
HOMEPAGE="https://github.com/KDE/clazy/blob/master/README.md"
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
	cmake-utils_src_prepare

	sed -e '/install(FILES README.md COPYING-LGPL2.txt checks.json DESTINATION/d' \
		-i CMakeLists.txt || die

	sed -e 's|${MAN_INSTALL_DIR}|share/man/man1|' \
		-i docs/man/CMakeLists.txt || die
}

src_install() {
	cmake-utils_src_install
	mv "${D}"/usr/share/doc/clazy/* "${D}"/usr/share/doc/${PF} || die
	rmdir "${D}"/usr/share/doc/clazy || die
}
