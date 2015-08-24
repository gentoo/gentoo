# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND=2

inherit eutils multilib fortran-2 python cmake-utils

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/free-cad/"
SRC_URI="mirror://sourceforge/free-cad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/eigen:3
	dev-games/ode
	<dev-libs/boost-1.57
	dev-libs/libf2c
	dev-libs/libspnav[X]
	dev-libs/xerces-c[icu]
	dev-python/PyQt4[svg]
	dev-python/pivy
	dev-qt/designer:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
	media-libs/SoQt
	media-libs/coin[doc]
	sci-libs/opencascade:6.7.1
	sys-libs/zlib
	virtual/glu"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.4-r1:0"

# https://bugs.gentoo.org/show_bug.cgi?id=352435
# https://www.gentoo.org/foundation/en/minutes/2011/20110220_trustees.meeting_log.txt
RESTRICT="bindist mirror"

S="${WORKDIR}/FreeCAD-${PV}"

pkg_setup() {
	fortran-2_pkg_setup
	python_set_active_version 2

	[ -z "${CASROOT}" ] && die "empty \$CASROOT, run eselect opencascade set or define otherwise"
}

src_prepare() {
	einfo remove bundled libs
	rm -rf src/3rdParty/{Pivy{,-0.5},boost}
	einfo cleanup build system
	find . -name "configure*" -print -delete

	epatch \
		"${FILESDIR}"/${P}-gcc46.patch \
		"${FILESDIR}"/${P}-removeoldswig.patch \
		"${FILESDIR}"/${P}-glu.patch \
		"${FILESDIR}"/${P}-nodir.patch \
		"${FILESDIR}"/${P}-qt3support.patch \
		"${FILESDIR}"/${P}-boost148.patch \
		"${FILESDIR}"/${P}-nopivy.patch \
		"${FILESDIR}"/${P}-no-permissive.patch \
		"${FILESDIR}"/${P}-cmake-2.8.12.patch \
		"${FILESDIR}"/${P}-occ-6.5.5.patch \
		"${FILESDIR}"/${P}-salomesmesh-occ-6.5.5.patch \
		"${FILESDIR}"/${P}-occ-6.6.patch

	local my_coin_version=$(best_version media-libs/coin)
	local my_coin_path="${EROOT}"usr/share/doc/${my_coin_version##*/}/html
	sed -e "s:/usr/share/doc/libcoin60-doc/html:${my_coin_path}:" \
		-i cMake/FindCoin3DDoc.cmake || die

	sed -e '/FREECAD_BUILD_FEM/s: ON): OFF):' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/inc
		-DOCC_INCLUDE_PATH="${CASROOT}"/inc
		-DOCC_LIBRARY="${CASROOT}"/lib/libTKernel.so
		-DOCC_LIBRARY_DIR="${CASROOT}"/lib
		-DOCC_LIB_PATH="${CASROOT}"/lib
		-DCOIN3D_INCLUDE_DIR="${EROOT}"usr/include/coin
		-DCOIN3D_LIBRARY="${EROOT}"usr/$(get_libdir)/libCoin.so
		-DSOQT_LIBRARY="${EROOT}"usr/$(get_libdir)/libSoQt.so
		-DSOQT_INCLUDE_PATH="${EROOT}"usr/include/coin
		-DCMAKE_INSTALL_PREFIX="${EROOT}"usr/$(get_libdir)/${P}
	)
	cmake-utils_src_configure
	ewarn "${P} will be built against opencascade version ${CASROOT}"
}

src_install() {
	cmake-utils_src_install
	insinto /usr/$(get_libdir)/${P}/Mod/Start
	doins -r src/Mod/Start/StartPage

	prune_libtool_files

	make_wrapper FreeCAD \
		"${EROOT}"usr/$(get_libdir)/${P}/bin/FreeCAD \
		"" "${EROOT}"usr/$(get_libdir)/${P}/lib
	make_wrapper FreeCADCmd \
		"${EROOT}"usr/$(get_libdir)/${P}/bin/FreeCADCmd \
		"" "${EROOT}"usr/$(get_libdir)/${P}/lib

	newicon src/Main/icon.ico ${PN}.ico
	make_desktop_entry FreeCAD

	dodoc README.Linux ChangeLog.txt
}
