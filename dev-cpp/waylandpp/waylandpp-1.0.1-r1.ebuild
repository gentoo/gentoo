# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Wayland C++ bindings"
HOMEPAGE="https://github.com/NilsBrause/waylandpp"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="doc"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/NilsBrause/waylandpp.git"
	inherit git-r3
else
	SRC_URI="https://github.com/NilsBrause/waylandpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

BDEPEND="
	>=dev-libs/pugixml-1.9-r1
"
RDEPEND="${BDEPEND}
	>=dev-libs/wayland-1.11.0
"
DEPEND="${RDEPEND}
	media-libs/libglvnd
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

src_configure() {
	unset BUILD_NATIVE
	local mycmakeargs

	if tc-is-cross-compiler; then
		mycmakeargs=(
			-DBUILD_DOCUMENTATION=off
			-DBUILD_LIBRARIES=off
		)
		BUILD_NATIVE="${WORKDIR}/${P}_native"
		BUILD_DIR="${BUILD_NATIVE}" tc-env_build cmake_src_configure
	fi

	mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		${BUILD_NATIVE+-DWAYLAND_SCANNERPP="${BUILD_NATIVE}"/wayland-scanner++}
	)
	cmake_src_configure
}

src_compile() {
	if tc-is-cross-compiler; then
		BUILD_DIR="${BUILD_NATIVE}" cmake_src_compile
	fi

	cmake_src_compile
}
