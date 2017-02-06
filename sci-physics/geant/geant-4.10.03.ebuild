# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils versionator

MY_P=${PN}${PV}
SPV="$(get_version_component_range 1 ${PV}).$(get_version_component_range 2 ${PV}).$(printf %1d $(get_version_component_range 3 ${PV}))"

DESCRIPTION="Toolkit for simulation of passage of particles through matter"
HOMEPAGE="http://geant4.cern.ch/"
SRC_URI="http://geant4.cern.ch/support/source/${MY_P}.tar.gz"

LICENSE="geant4"
SLOT="4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+data dawn doc examples gdml geant3 inventor motif opengl
	raytracerx qt4 static-libs vrml zlib threads"

RDEPEND="
	dev-libs/expat
	>=sci-physics/clhep-2.3.3.0:2=
	dawn? ( media-gfx/dawn )
	gdml? ( dev-libs/xerces-c )
	motif? ( x11-libs/motif:0 )
	opengl? ( virtual/opengl )
	inventor? ( media-libs/SoXt )
	qt4? (
		dev-qt/qtgui:4
		opengl? ( dev-qt/qtopengl:4 ) )
	raytracerx? (
		x11-libs/libX11
		x11-libs/libXmu )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND} prefix? ( app-shells/tcsh )"
PDEPEND="
	data? ( ~sci-physics/geant-data-${PV} )
	doc? ( ~app-doc/geant-docs-${PV} )"

HTML_DOCS=( ReleaseNotes/ReleaseNotes${SPV}.html )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cmake-utils_src_prepare
	if ! use examples ; then
		sed -i '/install(DIRECTORY examples/,/)/d' CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DGEANT4_USE_SYSTEM_CLHEP=ON
		-DGEANT4_INSTALL_DATA=OFF
		-DUSE_GEANT4_BUILD_MULTITHREADED=$(usex threads)
		-DUSE_GEANT4_USE_NETWORKDAWN=$(usex dawn)
		-DUSE_GEANT4_USE_GDML=$(usex gdml)
		-DUSE_GEANT4_USE_G3TOG4=$(usex geant3)
		-DUSE_GEANT4_USE_XM=$(usex motif)
		-DUSE_GEANT4_USE_OPENGL_X11=$(usex opengl)
		-DUSE_GEANT4_USE_INVENTOR=$(usex inventor)
		-DUSE_GEANT4_USE_QT=$(usex qt4)
		-DUSE_GEANT4_USE_RAYTRACER_X11=$(usex raytracerx)
		-DUSE_GEANT4_USE_NETWORKVRML=$(usex vrml)
		-DUSE_GEANT4_USE_SYSTEM_ZLIB=$(usex zlib)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)
	if use inventor; then
		mycmakeargs+=(
			-DINVENTOR_INCLUDE_DIR="$(coin-config --includedir)"
			-DINVENTOR_SOXT_INCLUDE_DIR="$(coin-config --includedir)"
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	# adjust clhep linking flags for system clhep
	# binmake.gmk is only useful for legacy build systems
	sed -i -e 's/-lG4clhep/-lCLHEP/' config/binmake.gmk || die
	cmake-utils_src_install
	[[ -f ReleaseNotes/Patch${SPV}-1.txt ]] && DOCS+=( ReleaseNotes/Patch${SPV}-*.txt )
	einstalldocs
}

pkg_postinst() {
	elog "The following scripts are provided for backward compatibility:"
	elog "$(ls -1 ${EROOT%/}/usr/share/${PN^}${SPV}.*/geant4make/*sh)"
}
