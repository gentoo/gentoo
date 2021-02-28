# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake git-r3 python-any-r1 toolchain-funcs

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
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-text/asciidoc )
"

src_prepare() {
	sed -i \
		-e '/^install.*LICENSEDIR/d' \
		-e '/set(DOCDIR / s#.*#set(DOCDIR ${CMAKE_INSTALL_DOCDIR})#' \
		CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# Ensure that 'python3' is in PATH. #765118
	python_setup

	mycmakeargs=(
		-DWITH_DOCUMENTATION=$(usex doc)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use examples; then
		rm -r "${ED}"/usr/share/doc/${PF}/examples || die
	fi
}
