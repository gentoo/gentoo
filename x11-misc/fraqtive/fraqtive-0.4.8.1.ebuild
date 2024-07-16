# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils toolchain-funcs xdg

DESCRIPTION="Open source, multi-platform generator of the Mandelbrot family fractals"
HOMEPAGE="https://fraqtive.mimec.org/ https://github.com/mimecorg/fraqtive"
SRC_URI="https://github.com/mimecorg/fraqtive/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtxml:5
	virtual/glu
"
RDEPEND="${DEPEND}"

src_configure() {
	tc-export PKG_CONFIG
	sed -i -e "s|-lGLU|$( ${PKG_CONFIG} --libs glu )|g" src/src.pro || die
	local conf="release"

	if use cpu_flags_x86_sse2; then
		conf="$conf sse2"
	else
		conf="$conf no-sse2"
	fi

	echo "CONFIG += $conf" > config.pri || die
	echo "PREFIX = ${EPREFIX}/usr" >> config.pri || die
	# Don't strip wrt #252096
	echo "QMAKE_STRIP =" >> config.pri || die

	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
