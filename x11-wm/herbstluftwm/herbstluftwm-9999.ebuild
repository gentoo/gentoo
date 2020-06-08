# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs cmake-utils

DESCRIPTION="A manual tiling window manager for X"
HOMEPAGE="https://herbstluftwm.org/"
EGIT_REPO_URI="https://github.com/herbstluftwm/herbstluftwm"

LICENSE="BSD-2"
SLOT="0"
IUSE="doc examples"

DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
"
RDEPEND="
	${DEPEND}
	app-shells/bash
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/asciidoc )
"

src_prepare() {
	sed -i \
		-e '/^install.*LICENSEDIR/d' \
		-e '/set(DOCDIR / s#.*#set(DOCDIR ${CMAKE_INSTALL_DOCDIR})#' \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DWITH_DOCUMENTATION=$(usex doc)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use examples; then
		rm -r "${ED}"/usr/share/doc/${PF}/examples || die
	fi
}
