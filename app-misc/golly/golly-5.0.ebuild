# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
WX_GTK_VER="3.2-gtk3"

inherit desktop python-single-r1 toolchain-funcs wxwidgets xdg

DESCRIPTION="Simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/
	https://sourceforge.net/projects/golly/"

SRC_URI="https://downloads.sourceforge.net/${PN}/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	virtual/zlib:=
	virtual/opengl
	x11-libs/wxGTK:${WX_GTK_VER}=[X,curl,opengl,sdl,tiff]
	${PYTHON_DEPS}
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-4.0-CFLAGS.patch" )

src_configure() {
	setup-wxwidgets
}

src_compile() {
	local -a emakeopts=(
		ENABLE_SOUND="yes"

		GOLLYDIR="${EPREFIX}/usr/share/${PN}"
		PYTHON="${EPYTHON}"
		WX_CONFIG="${WX_CONFIG}"

		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		CXXC="$(tc-getCXX)"
		RANLIB="$(tc-getRANLIB)"
	)
	emake -C gui-wx -f makefile-gtk "${emakeopts[@]}"
}

src_install() {
	# Has no 'make install', let's install files manually.
	dobin golly bgolly

	insinto "/usr/share/${PN}"
	doins -r Help Patterns Scripts Rules docs

	newicon --size 32 gui-wx/icons/appicon.xpm "${PN}.xpm"

	# WARNING: Does not run on wayland, we have to add "GDK_BACKEND" var.
	#  > This program wasn't compiled with EGL support required under Wayland
	make_desktop_entry "env GDK_BACKEND=x11 ${PN}" "Golly" "${PN}" "Science"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
