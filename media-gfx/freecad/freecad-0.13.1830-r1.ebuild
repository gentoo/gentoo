# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/freecad/freecad-0.13.1830-r1.ebuild,v 1.7 2015/07/23 21:37:17 xmw Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils fortran-2 multilib python-single-r1

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="http://www.freecadweb.org/"
SRC_URI="mirror://sourceforge/free-cad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-cpp/eigen:3
	dev-games/ode
	dev-libs/boost
	dev-libs/libf2c
	dev-libs/libspnav[X]
	dev-libs/xerces-c[icu]
	dev-python/matplotlib
	dev-qt/designer:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
	media-libs/SoQt
	media-libs/coin[doc]
	sci-libs/gts
	|| ( sci-libs/opencascade:6.7.1 sci-libs/opencascade:6.6.0 sci-libs/opencascade:6.5.5 )
	sys-libs/zlib
	virtual/glu
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	dev-qt/assistant:4
	dev-python/pycollada
	dev-python/pivy
	dev-python/PyQt4[svg]
	dev-python/pyopencl
	dev-python/numpy"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/swig-2.0.4-r1:0"

# http://bugs.gentoo.org/show_bug.cgi?id=352435
# http://www.gentoo.org/foundation/en/minutes/2011/20110220_trustees.meeting_log.txt
RESTRICT="bindist mirror"

# TODO:
#   DEPEND and RDEPEND:
#		salome-smesh - science overlay
#		zipio++ - not in portage yet

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup

	[ -z "${CASROOT}" ] && die "empty \$CASROOT, run eselect opencascade set or define otherwise"
}

src_prepare() {
	einfo remove bundled libs
	rm -rf src/3rdParty/{boost,Pivy*}

	epatch "${FILESDIR}"/${P}-remove-qt3-support.patch
	epatch "${FILESDIR}"/${P}-cmake-2.8.12.patch
	epatch "${FILESDIR}"/${P}-CMakefile.patch
	epatch "${FILESDIR}"/${P}-avoid-include-salome.patch
	epatch "${FILESDIR}"/${P}-startpage-links.patch

	# disable Machining Distortion workbench because FEM will be disabled in src_configure()
	# and also because the same module has been removed upstream (commit c0e2c9)
	epatch "${FILESDIR}"/${P}-no-machdist.patch

	epatch  "${FILESDIR}"/${PN}-0.12.5284-occ-6.6.patch
	epatch  "${FILESDIR}"/${P}-occ-6.7.patch

	einfo "Patching cMake/FindCoin3DDoc.cmake ..."
	local my_coin_version=$(best_version media-libs/coin)
	local my_coin_path="${EROOT}"usr/share/doc/${my_coin_version##*/}/html
	sed -e "s:/usr/share/doc/libcoin60-doc/html:${my_coin_path}:" \
		-i cMake/FindCoin3DDoc.cmake || die
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
		-DCMAKE_INSTALL_DATADIR="${EROOT}"usr/share/${P}/
		-DCMAKE_INSTALL_DOCDIR="${EROOT}"usr/share/doc/${P}/
		-DCMAKE_INSTALL_INCLUDEDIR="${EROOT}"usr/include/${P}/
		-DFREECAD_USE_EXTERNAL_PIVY="ON"
		-DFREECAD_BUILD_FEM="OFF"
	)

	# TODO to remove embedded dependencies:
	#
	#	-DFREECAD_USE_EXTERNAL_ZIPIOS="ON" -- this option needs zipios++ but it's not yet in portage so the embedded zipios++
	#                (under src/zipios++) will be used
	#	salomesmesh is in 3rdparty but upstream's find_package function is not complete yet to compile against external version
	#                (external salomesmesh is available in "science" overlay)

	cmake-utils_src_configure
	ewarn "${P} will be built against opencascade version ${CASROOT}"
}

src_install() {
	cmake-utils_src_install

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

	# disable compression of QT assistant help files
	>> "${ED}"usr/share/doc/${P}/freecad.qhc.ecompress.skip
	>> "${ED}"usr/share/doc/${P}/freecad.qch.ecompress.skip

	python_optimize "${ED}"usr/{$(get_libdir),share}/${P}/Mod/
}
