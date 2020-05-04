# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs cmake-utils

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/herbstluftwm/herbstluftwm"
	BDEPEND="app-text/asciidoc"
else
	SRC_URI="https://herbstluftwm.org/tarballs/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	BDEPEND=""
fi

DESCRIPTION="A manual tiling window manager for X"
HOMEPAGE="https://herbstluftwm.org/"

LICENSE="BSD-2"
SLOT="0"
IUSE="examples xinerama zsh-completion"

DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	xinerama? ( x11-libs/libXinerama )
"
RDEPEND="
	${DEPEND}
	app-shells/bash
	zsh-completion? ( app-shells/zsh )
"
BDEPEND+="
	virtual/pkgconfig
"

src_configure() {
	sed -i \
		-e '/^install.*LICENSEDIR/d' \
		-e '/set(DOCDIR / s#.*#set(DOCDIR ${CMAKE_INSTALL_DOCDIR})#' \
		CMakeLists.txt || die

	mycmakeargs=(
		-DWITH_XINERAMA=$(usex xinerama)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use examples; then
		rm -r "${ED}"/usr/share/doc/${PF}/examples || die
	fi

	if ! use zsh-completion; then
		rm -r "${ED}"/usr/share/zsh || die
	fi
}
