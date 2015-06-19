# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/freemat/freemat-4.2.ebuild,v 1.2 2014/12/06 21:05:59 tamiko Exp $

EAPI=5

inherit eutils cmake-utils fdo-mime

MY_PN=FreeMat
MY_P=${MY_PN}-${PV}

DESCRIPTION="Environment for rapid engineering and scientific processing"
HOMEPAGE="http://freemat.sourceforge.net/"
SRC_URI="mirror://sourceforge/freemat/${MY_P}-Source.tar.gz"

IUSE="volpack vtk"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libpcre
	media-libs/portaudio
	sci-libs/arpack
	sci-libs/fftw:3.0
	sci-libs/matio
	sci-libs/umfpack
	sys-libs/ncurses
	virtual/glu
	virtual/lapack
	virtual/libffi
	virtual/opengl
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	volpack? ( media-libs/volpack )
	vtk? ( sci-libs/vtk )"

DEPEND="${RDEPEND}
	dev-lang/python
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}-Source"

src_prepare(){
	epatch \
		"${FILESDIR}"/${PN}-4.1-fixes.patch \
		"${FILESDIR}"/${PN}-4.1-python3.patch \
		"${FILESDIR}"/${P}-use_llvm.patch
	rm -f CMakeCache.txt
	find . -type f -name '*.moc.cpp' -exec rm -f {} \;
	find . -type f -name 'add.so' -exec rm -f {} \;
}

src_configure() {
	mycmakeargs+=(
		-DFORCE_SYSTEM_LIBS=ON
		-DUSE_LLVM=OFF
		-DUSE_ITK=OFF
		-DFFI_INCLUDE_DIR="$(pkg-config --cflags-only-I libffi | sed -e s/-I//)"
		$(cmake-utils_use_with volpack VOLPACK)
		$(cmake-utils_use_with vtk VTK)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install -j1
	dodoc ChangeLog
	newicon images/freemat_small_mod_64.png ${PN}.png
	make_desktop_entry FreeMat FreeMat
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	elog "Before using ${MY_PN}, do (as a normal user)"
	elog "FreeMat -i ${EROOT}usr/share/${MY_P}"
	elog "Then start ${MY_PN}, choose Tools -> Path Tool,"
	elog "select ${EROOT}usr/share/${MY_P}/toolbox and Add With Subfolders"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
