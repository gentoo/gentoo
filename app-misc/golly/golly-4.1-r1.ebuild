# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER=3.0-gtk3
PYTHON_COMPAT=( python3_{9,10} )

inherit desktop python-single-r1 toolchain-funcs wxwidgets xdg

DESCRIPTION="simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	sys-libs/zlib
	virtual/opengl
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,sdl,tiff]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-4.0-CFLAGS.patch )

pkg_setup() {
	python-single-r1_pkg_setup
	setup-wxwidgets
}

src_compile() {
	local mymakeopts=(
		ENABLE_SOUND=yes
		GOLLYDIR="${EPREFIX}/usr/share/${PN}"
		PYTHON=${EPYTHON}
		WX_CONFIG=${WX_CONFIG}
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		CXXC="$(tc-getCXX)"
		RANLIB="$(tc-getRANLIB)"
	)
	emake -C gui-wx -f makefile-gtk "${mymakeopts[@]}"
}

src_install() {
	# has no 'make install' Let's install files manually.
	dobin golly bgolly
	insinto /usr/share/${PN}
	doins -r Help Patterns Scripts Rules docs

	newicon --size 32 gui-wx/icons/appicon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Golly" ${PN} "Science"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
